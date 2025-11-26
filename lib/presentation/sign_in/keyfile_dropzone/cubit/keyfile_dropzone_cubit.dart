import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:web/web.dart';

import 'keyfile_dropzone_state.dart';

@injectable
class KeyfileDropzoneCubit extends Cubit<KeyfileDropzoneState> {
  KeyfileDropzoneCubit() : super(KeyfileDropzoneState.empty());

  Future<void> uploadFileViaHtml(File file) async {
    updateSelectedFile(await FileModel.fromHtmlFile(file));
  }

  Future<void> uploadFileManually() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (filePickerResult == null) {
      return;
    }
    PlatformFile platformFile = filePickerResult.files.single;
    if (platformFile.bytes == null) {
      return;
    }

    updateSelectedFile(FileModel.fromPlatformFile(platformFile));
  }

  void updateSelectedFile(FileModel fileModel) {
    try {
      Map<String, dynamic> keyfileJson = jsonDecode(fileModel.content) as Map<String, dynamic>;
      AKeyfileEntity keyfileEntity = AKeyfileEntity.fromJson(keyfileJson);
      AEncryptedKeyfileModel encryptedKeyfileModel = AEncryptedKeyfileModel.fromEntity(keyfileEntity);
      emit(KeyfileDropzoneState(encryptedKeyfileModel: encryptedKeyfileModel, fileModel: fileModel));
    } on KeyfileException catch (keyfileException) {
      getIt<Logger>().e(keyfileException.keyfileExceptionType.toString());
      emit(KeyfileDropzoneState(keyfileExceptionType: keyfileException.keyfileExceptionType, fileModel: fileModel));
    } catch (e) {
      getIt<Logger>().e('Invalid keyfile: $e');
      emit(KeyfileDropzoneState(keyfileExceptionType: KeyfileExceptionType.invalidKeyfile, fileModel: fileModel));
    }
  }
}
