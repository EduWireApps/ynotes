part of school_api;

abstract class HomeworkRepository extends Repository {
  HomeworkRepository(SchoolApi api) : super(api);

  Future<Response<List<Homework>>> getDay(DateTime date);
}
