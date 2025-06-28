import 'package:flutter/material.dart';
import 'package:test_task_mobile/common/services/data/request_method_enum.dart';
import 'package:test_task_mobile/common/services/data/request_service_exception.model.dart';
import 'package:test_task_mobile/common/services/data/response_data.model.dart';
import 'package:test_task_mobile/common/services/request_service.dart';
import 'package:test_task_mobile/features/request/widgets/collapsable_text_field.dart';
import 'package:test_task_mobile/features/request/widgets/titled_switch.dart';

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

  Future<void> _performRequest() async {
    if (_textController.text.isEmpty) {
      return;
    }

    _requestService.setUrl(_textController.text);

    try {
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
      // TODO(Oleg): Add something to show in UI.
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
      actions: [
        IconButton(
          onPressed: () async => _performRequest(),
          icon: Icon(Icons.play_arrow),
        ),
      ],
    ),
    body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(controller: _textController),
        ),
        TitledSwitch(
          title: 'Защищенное соединение',
          value: _requestService.useHttps,
          onChanged: (_) => _requestService.toggleHttps(),
        ),
        TitledSwitch(
          title: 'Валидация соединения',
          value: _requestService.shouldValidate,
          enabled: _requestService.useHttps,
          onChanged: (_) => _requestService.toggleValidation(),
        ),
        DropdownButton(
          items:
              RequestMethod.values
                  .map<DropdownMenuItem<RequestMethod>>(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name.toUpperCase()),
                    ),
                  )
                  .toList(),
          onChanged: (value) => _requestService.setMethod(value!),
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
            children: [
              Text('Response info:'),
              Text('Status: ${response!.status}'),
              Text('Message: ${response!.message}'),
              Text('Data: ${response!.data}'),
            ],
          );
}
