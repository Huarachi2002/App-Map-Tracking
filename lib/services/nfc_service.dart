import 'dart:convert';

import 'package:app_map_tracking/models/pago.dart';
import 'package:app_map_tracking/models/payment_transaction.dart';
import 'package:app_map_tracking/models/tarjeta.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;

class NfcService {
  Future<bool> isNFCAvailable() async {
    try {
      final nfcAvailable = await FlutterNfcKit.nfcAvailability;
      return nfcAvailable == NFCAvailability.available;
    } catch (e) {
      print('Error verificando disponibilidad NFC: $e');
      return false;
    }
  }

  Future<Tarjeta?> leerTarjeta() async {
    try {
      final nfcAvailability = await FlutterNfcKit.nfcAvailability;
      if (nfcAvailability != NFCAvailability.available) {
        throw Exception('NFC no disponible');
      }

      print("Iniciando lectura de tarjeta NFC...");
      final tag = await FlutterNfcKit.poll(
        iosMultipleTagMessage: 'Selecciona una etiqueta',
        iosAlertMessage: 'Acerca tu dispositivo a la etiqueta NFC',
      );

      print("Etiqueta NFC detectada: ${tag.id}");

      final ndefData = await FlutterNfcKit.readNDEFRawRecords();
      print("Datos NDEF leídos: $ndefData");

      if (ndefData.isNotEmpty) {
        for (var record in ndefData) {
          if (record.typeNameFormat == 1 && record.type == 'T') {
            final payload = record.payload;
            final data = String.fromCharCodes(payload.codeUnits).substring(3);
            final jsonData = jsonDecode(data);

            return Tarjeta(
                id: jsonData['id_tarjeta'],
                idUsuario: jsonData['id_usuario'],
                tipoTarjeta: jsonData['tipo_tarjeta'],
                nfcId: tag.id,
                saldoActual: jsonData['saldo_actual'].toDouble(),
                estado: jsonData['estado'] == 1,
                fechaRegistro:
                    DateTime.fromMillisecondsSinceEpoch(jsonData['timestamp']));
          }
        }
      }

      await FlutterNfcKit.finish();
      if (tag.id.isNotEmpty) {
        return Tarjeta(
          id: 'new_card_${DateTime.now().millisecondsSinceEpoch}',
          idUsuario: 'pendiente',
          tipoTarjeta: 'fisica',
          nfcId: tag.id,
          saldoActual: 0.0,
          estado: true,
          fechaRegistro: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      print('Error al leer la tarjeta NFC: $e');
      await FlutterNfcKit.finish(iosErrorMessage: 'Error de lectura: $e');
      return null;
    }
  }

  Future<Pago?> registrarPagoNFC(Tarjeta tarjeta, double monto, String idMicro,
      double lat, double lng) async {
    try {
      final nfcAvailability = await FlutterNfcKit.nfcAvailability;
      if (nfcAvailability != NFCAvailability.available) {
        throw Exception('NFC no disponible');
      }

      if (tarjeta.saldoActual < monto) {
        throw Exception('Saldo insuficiente en la tarjeta');
      }

      final pago = Pago(
        id: 'pago_${DateTime.now().millisecondsSinceEpoch}',
        idTarjeta: tarjeta.id,
        montoPagado: monto,
        modoPago: 'NFC',
        estado: 'completado',
        latitud: lat,
        longitud: lng,
        idMicro: idMicro,
        fechaRegistro: DateTime.now(),
      );

      print("Iniciando el modo de pago NFC...");

      await FlutterNfcKit.poll(
        iosMultipleTagMessage: 'Selecciona una etiqueta',
        iosAlertMessage: 'Acerca tu dispositivo a la etiqueta NFC',
      );

      final nfcData = pago.toNfcFormat();
      final JsonCodec = jsonEncode(nfcData);

      final ndefRecord = ndef.TextRecord(text: JsonCodec, language: 'es');

      await FlutterNfcKit.writeNDEFRecords([ndefRecord]);

      await FlutterNfcKit.finish(
        iosAlertMessage: 'Pago registrado: ${pago.id}',
      );

      return pago;
    } catch (e) {
      print('Error al registrar el pago NFC: $e');
      await FlutterNfcKit.finish(
        iosErrorMessage: 'Error de registro: $e',
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> iniciarModoLector(double tarifaPasaje) async {
    try {
      final nfcAvailability = await FlutterNfcKit.nfcAvailability;
      if (nfcAvailability != NFCAvailability.available) {
        throw Exception('NFC no disponible');
      }

      print("Iniciando lectura de pago NFC...");
      final tag = await FlutterNfcKit.poll(
        iosMultipleTagMessage: 'Selecciona una etiqueta',
        iosAlertMessage: 'Acerca tu dispositivo a la etiqueta NFC',
      );

      print("Etiqueta NFC detectada: ${tag.id}");

      final ndefData = await FlutterNfcKit.readNDEFRawRecords();
      print("Datos NDEF leídos: $ndefData");

      Tarjeta? tarjeta;

      if (ndefData.isNotEmpty) {
        for (var record in ndefData) {
          if (record.typeNameFormat == 1 && record.type == 'T') {
            final payload = record.payload;
            final data = String.fromCharCodes(payload.codeUnits).substring(3);
            final jsonData = jsonDecode(data);

            tarjeta = Tarjeta(
                id: jsonData['id_tarjeta'],
                idUsuario: jsonData['id_usuario'],
                tipoTarjeta: jsonData['tipo_tarjeta'],
                nfcId: tag.id,
                saldoActual: jsonData['saldo_actual'].toDouble(),
                estado: jsonData['estado'],
                fechaRegistro:
                    DateTime.fromMillisecondsSinceEpoch(jsonData['timestamp']));
          }
        }
      }

      if (tarjeta == null && tag.id.isNotEmpty) {
        tarjeta = Tarjeta(
          id: 'unknown_card',
          idUsuario: 'desconocido',
          tipoTarjeta: 'fisica',
          nfcId: tag.id,
          saldoActual: 0.0, // No conocemos el saldo
          estado: false,
          fechaRegistro: DateTime.now(),
        );
      }

      if (tarjeta == null) {
        throw Exception('No se pudo leer la tarjeta NFC');
      }

      if (tarjeta.saldoActual < tarifaPasaje) {
        return {
          'success': false,
          'tarjeta': tarjeta,
          'error': 'Saldo insuficiente'
        };
      }

      final nuevoPago = Pago(
        id: 'pago_${DateTime.now().millisecondsSinceEpoch}',
        idTarjeta: tarjeta.id,
        montoPagado: tarifaPasaje,
        modoPago: 'NFC',
        estado: 'completado',
        latitud: 0.0, // Se actualizaría con la ubicación real
        longitud: 0.0, // Se actualizaría con la ubicación real
        idMicro: 'micro_actual', // Se actualizaría con el ID real del micro
        fechaRegistro: DateTime.now(),
      );

      final tarjetaActualizada = Tarjeta(
        id: tarjeta.id,
        idUsuario: tarjeta.idUsuario,
        tipoTarjeta: tarjeta.tipoTarjeta,
        nfcId: tarjeta.nfcId,
        saldoActual: tarjeta.saldoActual - tarifaPasaje,
        estado: tarjeta.estado,
        fechaRegistro: tarjeta.fechaRegistro,
      );

      final nfcData = tarjetaActualizada.toNfcFormat();
      final jsonStr = jsonEncode(nfcData);

      final ndefRecord = ndef.TextRecord(text: jsonStr, language: 'es');

      await FlutterNfcKit.writeNDEFRecords([ndefRecord]);

      await FlutterNfcKit.finish(
          iosAlertMessage: 'Pago procesado correctamente');

      return {
        'success': true,
        'tarjeta': tarjetaActualizada,
        'pago': nuevoPago,
      };
    } catch (e) {
      print('Error al leer el pago NFC: $e');
      await FlutterNfcKit.finish(iosErrorMessage: 'Error de lectura: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<bool> actualizarSaldoTarjeta(
      Tarjeta tarjeta, double nuevoSaldo) async {
    try {
      final nfcAvailability = await FlutterNfcKit.nfcAvailability;
      if (nfcAvailability != NFCAvailability.available) {
        throw Exception('NFC no disponible');
      }

      print("Iniciando actualización de saldo NFC...");
      await FlutterNfcKit.poll(
        iosMultipleTagMessage: 'Selecciona una etiqueta',
        iosAlertMessage: 'Acerca tu dispositivo a la etiqueta NFC',
      );

      final tarjetaActualizada = Tarjeta(
        id: tarjeta.id,
        idUsuario: tarjeta.idUsuario,
        tipoTarjeta: tarjeta.tipoTarjeta,
        nfcId: tarjeta.nfcId,
        saldoActual: nuevoSaldo,
        estado: tarjeta.estado,
        fechaRegistro: tarjeta.fechaRegistro,
      );

      final nfcData = tarjetaActualizada.toNfcFormat();
      final jsonStr = jsonEncode(nfcData);

      final ndefRecord = ndef.TextRecord(text: jsonStr, language: 'es');

      await FlutterNfcKit.writeNDEFRecords([ndefRecord]);

      await FlutterNfcKit.finish(
        iosAlertMessage: 'Saldo actualizado: ${tarjetaActualizada.id}',
      );

      return true;
    } catch (e) {
      print('Error al actualizar el saldo NFC: $e');
      await FlutterNfcKit.finish(
        iosErrorMessage: 'Error de actualización: $e',
      );
      return false;
    }
  }

  //TODO: Ver si se llegara a utilizar Procesos de emulación de tarjeta

  Future<void> startCardEmulation(PaymentTransaction transaction) async {
    try {
      print(
          "Iniciando emulación de tarjeta con datos: ${transaction.toJson()}");
    } catch (e) {
      print('Error al iniciar la emulación de tarjeta: $e');
      throw Exception('No se pudo iniciar el modo de pago: $e');
    }
  }

  Future<PaymentTransaction?> startReaderMode() async {
    try {
      final nfcAvailability = await FlutterNfcKit.nfcAvailability;
      if (nfcAvailability != NFCAvailability.available) {
        throw Exception('NFC no disponible');
      }

      print("Iniciando el modo lector NFC...");
      final tag = await FlutterNfcKit.poll(
        iosMultipleTagMessage: 'Selecciona una etiqueta',
        iosAlertMessage: 'Acerca tu dispositivo a la etiqueta NFC',
      );

      print("Etiqueta NFC detectada: ${tag.id}");

      final ndefData = await FlutterNfcKit.readNDEFRawRecords();
      print("Datos NDEF leídos: $ndefData");

      if (ndefData.isNotEmpty) {
        for (var record in ndefData) {
          if (record.typeNameFormat == 1 && record.type == 'T') {
            final payload = record.payload;
            final data = String.fromCharCodes(payload.codeUnits).substring(3);
            final jsonData = jsonDecode(data);

            return PaymentTransaction(
                id: jsonData['transaction_id'],
                amount: jsonData['amount'].toDouble(),
                currency: '${jsonData['currency']}',
                timestamp:
                    DateTime.fromMicrosecondsSinceEpoch(jsonData['timestamp']),
                status: 'completed',
                cryptoType: jsonData['crypto_type'],
                cryptoAmount: jsonData['crypto_amount'].toDouble(),
                walletId: jsonData['wallet_id']);
          }
        }
      }

      await FlutterNfcKit.finish();
      return null;
    } catch (e) {
      print('Error al leer la etiqueta NFC: $e');
      await FlutterNfcKit.finish(iosErrorMessage: 'Error de lectura: $e');
      return null;
    }
  }

  Future<bool> sendPayment(PaymentTransaction transaction) async {
    try {
      print("Enviando pago: ${transaction.toJson()}");
      final nFCAvailability = await FlutterNfcKit.nfcAvailability;

      if (nFCAvailability != NFCAvailability.available) {
        throw Exception('NFC no disponible');
      }

      print("Iniciando el modo de pago NFC...");

      await FlutterNfcKit.poll(
        iosMultipleTagMessage: 'Selecciona una etiqueta',
        iosAlertMessage: 'Acerca tu dispositivo a la etiqueta NFC',
      );

      final ndefData = transaction.toNdefFormat();

      final jsonStr = jsonEncode(ndefData);

      final ndefRecord = ndef.TextRecord(text: jsonStr, language: 'es');

      await FlutterNfcKit.writeNDEFRecords([ndefRecord]);

      await FlutterNfcKit.finish(
        iosAlertMessage: 'Pago enviado: ${transaction.id}',
      );

      return true;
    } catch (e) {
      print('Error al enviar el pago: $e');
      await FlutterNfcKit.finish(
        iosErrorMessage: 'Error de envío: $e',
      );
      return false;
    }
  }
}
