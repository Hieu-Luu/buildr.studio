import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volta/models/tool.dart';
import 'package:volta/models/variable.dart';
import 'package:volta/screens/home_screen/file_explorer_state.dart';
import 'package:volta/screens/home_screen/variable_section_state.dart';

class VariableSection extends StatelessWidget {
  final Tool selectedTool;
  final List<Variable> variables;
  final VariableSectionState variableSectionState;

  const VariableSection({
    super.key,
    required this.selectedTool,
    required this.variables,
    required this.variableSectionState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Input',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: variables
                .map((variable) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: VariableInput(
                        variable: variable,
                        selectedPaths: variableSectionState.selectedPaths,
                        onPathsSelected: variableSectionState.onPathsSelected,
                        onValueChanged: variableSectionState.setInputValue,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class VariableInput extends StatefulWidget {
  final Variable variable;
  final List<String> selectedPaths;
  final void Function(List<String>) onPathsSelected;
  final void Function(String, String) onValueChanged;

  const VariableInput({
    super.key,
    required this.variable,
    required this.selectedPaths,
    required this.onPathsSelected,
    required this.onValueChanged,
  });

  @override
  State<VariableInput> createState() => _VariableInputState();
}

class _VariableInputState extends State<VariableInput> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '<${widget.variable.name.toUpperCase()}>',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Tooltip(
              message: widget.variable.description,
              child: const Icon(Icons.info_outline),
            )
          ],
        ),
        const SizedBox(height: 8),
        if (widget.variable.inputType == 'text_field')
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: widget.variable.hintLabel,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (value) {
              widget.onValueChanged(widget.variable.name, value);
            },
          )
        else if (widget.variable.inputType == 'dropdown')
          DropdownButtonFormField<String>(
            hint: Text(widget.variable.selectLabel!),
            items: [
              ...?widget.variable.sourceName
                  ?.split(',')
                  .map((option) => DropdownMenuItem(
                        value: option.trim(),
                        child: Text(option.trim()),
                      )),
            ],
            onChanged: (value) {
              if (value != null) {
                widget.onValueChanged(widget.variable.name, value);
              }
            },
          )
        else if (widget.variable.inputType == 'sources')
          SourcesInput(
            selectedPaths: widget.selectedPaths,
            onPathsSelected: widget.onPathsSelected,
          ),
      ],
    );
  }
}

class SourcesInput extends StatelessWidget {
  final List<String> selectedPaths;
  final void Function(List<String>) onPathsSelected;

  const SourcesInput({
    super.key,
    required this.selectedPaths,
    required this.onPathsSelected,
  });

  @override
  Widget build(BuildContext context) {
    final fileExplorerState = context.watch<FileExplorerState>();

    return DragTarget<List<String>>(
      onAcceptWithDetails: (details) {
        onPathsSelected(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isHighlighted || selectedPaths.isNotEmpty
                ? Colors.orange.shade50
                : null,
            border: Border.all(
              color: isHighlighted ? Colors.orange : Colors.grey.shade400,
              width: isHighlighted ? 4.0 : 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: selectedPaths.isNotEmpty
              ? Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: selectedPaths.map((path) {
                    try {
                      final isFolder = FileSystemEntity.isDirectorySync(path);
                      return Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isFolder) const Icon(Icons.folder, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              fileExplorerState.getDisplayFileName(path),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      // Log the error or display it to the UI
                      print('Error checking file type: $e');
                      return const SizedBox.shrink();
                    }
                  }).toList(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload_file, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Drag and drop your sources here',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey),
                    )
                  ],
                ),
        );
      },
    );
  }
}
