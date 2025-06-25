abstract class PasajeRepository {
  Future<double> getPrecioPasaje(String idEntidad);
  Future<Map<String, dynamic>> pagarPasajeConTarjeta({
    required String idTarjeta,
    required double monto,
    required String idMicro,
  });
}
