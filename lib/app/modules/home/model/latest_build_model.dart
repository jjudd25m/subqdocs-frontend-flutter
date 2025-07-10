class LatestBuildModel {
  LatestBuildResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  LatestBuildModel({this.responseData, this.message, this.toast, this.responseType});

  LatestBuildModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? LatestBuildResponseData.fromJson(json['responseData']) : null;
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (responseData != null) {
      data['responseData'] = responseData!.toJson();
    }
    data['message'] = message;
    data['toast'] = toast;
    data['response_type'] = responseType;
    return data;
  }
}

class LatestBuildResponseData {
  DataValues? dataValues;
  DataValues? dPreviousDataValues;
  int? uniqno;
  Options? oOptions;
  bool? isNewRecord;

  LatestBuildResponseData({this.dataValues, this.dPreviousDataValues, this.uniqno, this.oOptions, this.isNewRecord});

  LatestBuildResponseData.fromJson(Map<String, dynamic> json) {
    dataValues = json['dataValues'] != null ? DataValues.fromJson(json['dataValues']) : null;
    dPreviousDataValues = json['_previousDataValues'] != null ? DataValues.fromJson(json['_previousDataValues']) : null;
    uniqno = json['uniqno'];

    oOptions = json['_options'] != null ? Options.fromJson(json['_options']) : null;
    isNewRecord = json['isNewRecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dataValues != null) {
      data['dataValues'] = dataValues!.toJson();
    }
    if (dPreviousDataValues != null) {
      data['_previousDataValues'] = dPreviousDataValues!.toJson();
    }
    data['uniqno'] = uniqno;

    if (oOptions != null) {
      data['_options'] = oOptions!.toJson();
    }
    data['isNewRecord'] = isNewRecord;
    return data;
  }
}

class DataValues {
  int? id;
  String? buildType;
  String? versionNumber;
  bool? isForceUpdate;
  String? versionReleaseDate;
  String? versionSummary;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  DataValues({this.id, this.buildType, this.versionNumber, this.isForceUpdate, this.versionReleaseDate, this.versionSummary, this.createdAt, this.updatedAt, this.deletedAt});

  DataValues.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buildType = json['build_type'];
    versionNumber = json['version_number'];
    isForceUpdate = json['is_force_update'];
    versionReleaseDate = json['version_release_date'];
    versionSummary = json['version_summary'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['build_type'] = buildType;
    data['version_number'] = versionNumber;
    data['is_force_update'] = isForceUpdate;
    data['version_release_date'] = versionReleaseDate;
    data['version_summary'] = versionSummary;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class Options {
  bool? isNewRecord;
  String? nSchema;
  String? sSchemaDelimiter;
  bool? raw;
  List<String>? attributes;

  Options({this.isNewRecord, this.nSchema, this.sSchemaDelimiter, this.raw, this.attributes});

  Options.fromJson(Map<String, dynamic> json) {
    isNewRecord = json['isNewRecord'];
    nSchema = json['_schema'];
    sSchemaDelimiter = json['_schemaDelimiter'];
    raw = json['raw'];
    attributes = json['attributes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isNewRecord'] = isNewRecord;
    data['_schema'] = nSchema;
    data['_schemaDelimiter'] = sSchemaDelimiter;
    data['raw'] = raw;
    data['attributes'] = attributes;
    return data;
  }
}
