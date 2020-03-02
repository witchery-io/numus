class Output {
  final String script;
  final List addresses;
  final String scriptType;
  final String spentBy;

  Output({this.script, this.addresses, this.scriptType, this.spentBy});

  factory Output.fromJson(Map<String, dynamic> json) {
    return Output(
        addresses: json['addresses'],
        script: json['script'],
        scriptType: json['script_type'],
        spentBy: json['spent_by']);
  }
}
