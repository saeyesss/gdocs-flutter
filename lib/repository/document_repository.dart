import 'dart:convert';

import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:riverpod/riverpod.dart';
import 'package:gdocs_flutter/constants.dart';
import 'package:gdocs_flutter/models/document_model.dart';
import 'package:gdocs_flutter/models/error_model.dart';

final documentRepositoryProvider = Provider((ref) => DocumentRepository(
      client: Client(),
    ));

class DocumentRepository {
  final Client _client;
  DocumentRepository({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error =
        ErrorModel(error: "Some unexpected error occured.", data: null);
    try {
      var res = await _client.post(Uri.parse("$host/doc/create"),
          headers: {
            "Content-Type": "application/json; charSet=UTF-8",
            'x-auth-token': token,
          },
          body: jsonEncode({
            'createdAt': DateTime.now().microsecondsSinceEpoch,
          }));

      switch (res.statusCode) {
        case 200:
          error = ErrorModel(
            error: null,
            data: DocumentModel.fromJson(res.body),
          );
          break;
        default:
          error = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel error =
        ErrorModel(error: "Some unexpected error occured.", data: null);
    try {
      var res = await _client.get(
        Uri.parse("$host/docs/me"),
        headers: {
          "Content-Type": "application/json; charSet=UTF-8",
          'x-auth-token': token,
        },
      );

      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];

          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(
              DocumentModel.fromJson(
                jsonEncode(jsonDecode(res.body)[i]),
              ),
            );
          }
          error = ErrorModel(
            error: null,
            data: documents,
          );
          break;
        default:
          error = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}
