enum Status{
  notStarted,
  loading,
  ready,
  fail;

  bool get isLoading => this == Status.loading;
  bool get hasFailed => this == Status.fail;
  bool get hasFinished => this == Status.ready;
}