import 'package:flutter/material.dart';
import 'package:test_task_mobile/common/services/data/request_method_enum.dart';
import 'package:test_task_mobile/common/services/data/request_service_exception.model.dart';
import 'package:test_task_mobile/common/services/data/response_data.model.dart';
import 'package:test_task_mobile/common/services/request_service.dart';
import 'package:test_task_mobile/features/request/widgets/collapsable_text_field.dart';
import 'package:test_task_mobile/features/request/widgets/loader_dialog.dart';
import 'package:test_task_mobile/features/request/widgets/titled_switch.dart';
import 'package:test_task_mobile/common/utils/extensions.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  late RequestService _requestService;
  late TextEditingController _textController;

  ResponseDataModel? _response;

  @override
  void initState() {
    super.initState();

    _requestService = RequestService();
    _textController = TextEditingController(text: _requestService.url);
  }

  Future<void> _performRequest(BuildContext context) async {
    if (_textController.text.isEmpty) {
      return;
    }

    showLoaderDialog(context);

    setState(() {
      _response = null;
    });

    _requestService.setUrl(_textController.text);

    try {
      // Immitating the real request delay.
      // Should be removed in a real call.
      await Future.delayed(const Duration(milliseconds: 1500));

      // Fake result.
      setState(() {
        _response = ResponseDataModel.fake();
      });

      // Fake with bad connection.
      /*setState(() {
        _response = ResponseDataModel.connectionError();
      });*/

      // Fake with bad certificate.
      /*setState(() {
        _response = ResponseDataModel.certificateError();
      });*/

      // Fake with invalidData.
      /*setState(() {
        _response = ResponseDataModel.invalidResponseError();
      });*/

      // Real execution.
      /* final response = await _requestService.performRequest();

      setState(() {
        _response = response;
      });*/
    } on RequestServiceException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Unknown error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Closing the loader modal.
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  /// Parses headers string into Map and sets in [_requestService].
  void _setHeaders(String value) {
    // Removes all whitespaces and makes a list of header strings.
    final stringHeaders = value.replaceAll(' ', '').split(',');

    final newHeaders = Map.fromEntries(
      stringHeaders.map((e) {
        final separatedHeader = e.split(':');

        return MapEntry<String, dynamic>(
          separatedHeader.first,
          separatedHeader.last,
        );
      }),
    );

    _requestService.setHeaders(newHeaders);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: context.colorScheme.primary,
      actions: [
        // Builder is used here to get Scaffold in the context below.
        Builder(
          builder:
              (context) => IconButton(
                onPressed: () async => _performRequest(context),
                icon: Icon(
                  Icons.play_arrow,
                  color: context.colorScheme.onPrimary,
                ),
              ),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(10),
      children: [
        TextField(controller: _textController),
        TitledSwitch(
          title: 'Защищенное соединение',
          value: _requestService.useHttps,
          onChanged:
              (_) => setState(() {
                _requestService.toggleHttps();
              }),
        ),
        TitledSwitch(
          title: 'Валидация соединения',
          value: _requestService.shouldValidate,
          enabled: _requestService.useHttps,
          onChanged:
              (_) => setState(() {
                _requestService.toggleValidation();
              }),
        ),
        DropdownButton(
          isExpanded: true,
          items:
              RequestMethod.values
                  .map<DropdownMenuItem<RequestMethod>>(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name.toUpperCase()),
                    ),
                  )
                  .toList(),
          onChanged:
              (value) => setState(() {
                _requestService.setMethod(value!);
              }),
          value: _requestService.method,
        ),
        CollapsableTextField(title: 'Headers', onChanged: _setHeaders),
        CollapsableTextField(title: 'Data', onChanged: _requestService.setData),

        const Divider(),

        _ResponseInfo(response: _response),
      ],
    ),
  );
}

class _ResponseInfo extends StatelessWidget {
  const _ResponseInfo({required this.response});

  final ResponseDataModel? response;

  @override
  Widget build(BuildContext context) =>
      response == null
          ? SizedBox.shrink()
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Response info:', style: context.textTheme.headlineSmall),

              const SizedBox(height: 20),

              Text(
                'Status: ${response!.status}',
                style: context.textTheme.bodyLarge,
              ),
              Text(
                'Message: ${response!.message}',
                style: context.textTheme.bodyLarge,
              ),
              Text(
                'Data: ${response!.data}',
                style: context.textTheme.bodyLarge,
              ),
            ],
          );
}
