part of school_api;

abstract class EmailsRepository extends Repository {
  EmailsRepository(SchoolApi api) : super(api);

  Future<Response<String>> getEmailContent(Email email, bool received);

  Future<Response<void>> sendEmail(Email email);
}
