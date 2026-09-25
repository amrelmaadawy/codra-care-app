import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_appointment_result_entity.dart';
import '../entities/booking_form_context_entity.dart';
import '../entities/booking_patient_entity.dart';
import '../entities/create_appointment_params.dart';

abstract class ReceptionBookingRepository {
  Future<Either<Failure, BookingFormContextEntity>> getFormContext({
    int? doctorId,
    String? date,
  });

  Future<Either<Failure, List<BookingPatientEntity>>> searchPatients(
    String query,
  );

  Future<Either<Failure, BookingAppointmentResultEntity>> createAppointment(
    CreateAppointmentParams params,
  );
}
