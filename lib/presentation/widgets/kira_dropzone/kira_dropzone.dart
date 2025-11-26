import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:torii_client/presentation/widgets/kira_dropzone/kira_dropzone_drop_view.dart';
import 'package:torii_client/presentation/widgets/kira_dropzone/kira_dropzone_empty_view.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:web/web.dart';

typedef FilePreviewErrorBuilder = Widget Function(String? errorMessage);

// TODO: refactor, simplify
class KiraDropzone extends StatefulWidget {
  final bool hasFileBool;
  final double width;
  final double height;
  final String emptyLabel;
  final ValueChanged<File> uploadViaHtmlFile;
  final VoidCallback uploadFileManually;
  final FilePreviewErrorBuilder filePreviewErrorBuilder;
  final String? errorMessage;

  const KiraDropzone({
    required this.hasFileBool,
    required this.width,
    required this.height,
    required this.emptyLabel,
    required this.uploadViaHtmlFile,
    required this.uploadFileManually,
    required this.filePreviewErrorBuilder,
    this.errorMessage,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _KiraDropzone();
}

class _KiraDropzone extends State<KiraDropzone> {
  bool hoveredBool = false;

  @override
  Widget build(BuildContext context) {
    late Widget dropzonePreview;

    if (hoveredBool) {
      dropzonePreview = const KiraDropzoneDropView();
    } else if (widget.hasFileBool) {
      dropzonePreview = widget.filePreviewErrorBuilder(widget.errorMessage);
    } else {
      dropzonePreview = KiraDropzoneEmptyView(emptyLabel: widget.emptyLabel, onTap: widget.uploadFileManually);
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: widget.errorMessage != null ? DesignColors.redStatus1 : DesignColors.white1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DropzoneView(
              operation: DragOperation.all,
              cursor: CursorType.grab,
              onHover: () => _setHoverState(status: true),
              onDropFile: _listenFileDrop,
              onLeave: () => _setHoverState(status: false),
            ),
          ),
          Positioned.fill(
            child: InkWell(
              onTap: widget.uploadFileManually,
              child: Padding(padding: const EdgeInsets.all(10), child: dropzonePreview),
            ),
          ),
        ],
      ),
    );
  }

  void _listenFileDrop(dynamic file) {
    widget.uploadViaHtmlFile(file as File);
    _setHoverState(status: false);
  }

  void _setHoverState({required bool status}) {
    hoveredBool = status;
    setState(() {});
  }
}
