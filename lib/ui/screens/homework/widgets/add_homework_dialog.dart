import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/legacy/theme_utils.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/drag_handle.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

Future<Homework?> showAddHomeworkBottomSheet(context, {Homework? hw}) {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return AddHomeworkBottomSheet(
          defaultHW: hw,
        );
      });
}

// ignore: must_be_immutable
class AddHomeworkBottomSheet extends StatefulWidget {
  Homework? defaultHW;
  AddHomeworkBottomSheet({Key? key, this.defaultHW}) : super(key: key);
  @override
  _AddHomeworkBottomSheetState createState() => _AddHomeworkBottomSheetState();
}

class _AddHomeworkBottomSheetState extends State<AddHomeworkBottomSheet> {
  TextEditingController disciplineNameTextController = TextEditingController();

  TextEditingController contentTextController = TextEditingController();

  bool isATest = false;
  DateTime date = DateTime.now();
  Future<List<String?>> autocompleterCallback(String search) async {
    return (await appSys.api?.getGrades() ?? [])
        .where((element) => element.disciplineName?.toLowerCase().contains(search.toLowerCase()) ?? false)
        .map((e) => e.disciplineName)
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Wrap(alignment: WrapAlignment.center, children: [
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Theme.of(context).primaryColor),
          padding: EdgeInsets.symmetric(
              vertical: screenSize.size.height / 10 * 0.2, horizontal: screenSize.size.width / 5 * 0.2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DragHandle(),
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              Text(
                widget.defaultHW == null ? "Ajouter un nouveau devoir" : "Modifier un devoir existant",
                style: TextStyle(
                    fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: screenSize.size.height / 10 * 0.2,
              ),
              buildTextField(disciplineNameTextController, "Nom de la matière", autocompleterCallback),
              SizedBox(
                height: screenSize.size.height / 10 * 0.2,
              ),
              buildLargeTextField(contentTextController, "Contenu", autocompleterCallback),
              SizedBox(
                height: screenSize.size.height / 10 * 0.2,
              ),
              SwitchListTile(
                  title: Text(
                    "Ce devoir est un contrôle",
                    style: TextStyle(
                        fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.normal, fontSize: 20),
                  ),
                  value: isATest,
                  onChanged: (newValue) {
                    setState(() {
                      isATest = newValue;
                    });
                  }),
              SizedBox(
                height: screenSize.size.height / 10 * 0.2,
              ),
              buildDateChoice(),
              SizedBox(
                height: screenSize.size.height / 10 * 0.2,
              ),
              YButton(
                onPressed: () => process(context),
                text: "Ajouter",
                color: (disciplineNameTextController.text != "" && contentTextController.text != "")
                    ? YColor.success
                    : YColor.secondary,
              ),
            ],
          ),
        ),
      )
    ]);
  }

  Widget buildDateChoice() {
    var screenSize = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
      child: DateTimeFormField(
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ThemeUtils.textColor()),
          labelStyle: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
          counterStyle: TextStyle(color: ThemeUtils.textColor()),
          helperStyle: TextStyle(color: ThemeUtils.textColor()),
          prefixStyle: TextStyle(color: ThemeUtils.textColor()),
          suffixStyle: TextStyle(color: ThemeUtils.textColor()),
          errorStyle: const TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(borderSide: BorderSide(color: ThemeUtils.textColor())),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeUtils.textColor().withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeUtils.textColor().withOpacity(0.5)),
          ),
          suffixIcon: Icon(Icons.event_note, color: ThemeUtils.textColor()),
          labelText: "Choisissez une date",
        ),
        dateTextStyle: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
        dateFormat: DateFormat("EEEE dd MMMM yyyy", "fr_FR"),
        initialValue: date,
        mode: DateTimeFieldPickerMode.date,
        autovalidateMode: AutovalidateMode.always,
        onDateSelected: (DateTime value) {
          setState(() {
            date = value;
          });
        },
      ),
    );
  }

  Widget buildLargeTextField(TextEditingController con, String label, autoCompleter) {
    var screenSize = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: con,
                maxLines: 10,
                style: DefaultTextStyle.of(context).style.copyWith(fontFamily: "Asap", color: ThemeUtils.textColor()),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: ThemeUtils.textColor())),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeUtils.textColor().withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeUtils.textColor().withOpacity(0.5)),
                  ),
                  labelText: label,
                  labelStyle: TextStyle(
                    fontFamily: "Asap",
                    fontWeight: FontWeight.w500,
                    color: ThemeUtils.textColor().withOpacity(0.8),
                  ),
                )),
            suggestionsCallback: (String pattern) {
              return autoCompleter(pattern);
            },
            itemBuilder: (BuildContext context, dynamic discipline) {
              return ListTile(
                title: Text(discipline ?? ""),
              );
            },
            hideOnEmpty: true,
            onSuggestionSelected: (dynamic suggestion) {
              disciplineNameTextController.text = suggestion ?? "";
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController con, String label, autoCompleter) {
    var screenSize = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: con,
                style: DefaultTextStyle.of(context).style.copyWith(fontFamily: "Asap", color: ThemeUtils.textColor()),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: ThemeUtils.textColor())),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeUtils.textColor().withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeUtils.textColor().withOpacity(0.5)),
                  ),
                  labelText: label,
                  labelStyle: TextStyle(
                    fontFamily: "Asap",
                    fontWeight: FontWeight.w500,
                    color: ThemeUtils.textColor().withOpacity(0.8),
                  ),
                )),
            suggestionsCallback: (String pattern) {
              return autoCompleter(pattern);
            },
            itemBuilder: (BuildContext context, dynamic discipline) {
              return ListTile(
                title: Text(discipline ?? ""),
              );
            },
            hideOnEmpty: true,
            onSuggestionSelected: (dynamic suggestion) {
              disciplineNameTextController.text = suggestion ?? "";
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  generateID() {
    return date.toString() +
        disciplineNameTextController.text.hashCode.toString() +
        contentTextController.text.hashCode.toString();
  }

  @override
  initState() {
    super.initState();
    processExistingHW();
  }

  process(BuildContext context) {
    if (disciplineNameTextController.text != "" && contentTextController.text != "") {
      widget.defaultHW ??= Homework();
      widget.defaultHW!
        ..date = date
        ..discipline = disciplineNameTextController.text
        ..disciplineCode = disciplineNameTextController.text.hashCode.toString()
        ..rawContent = contentTextController.text
        ..isATest = isATest
        ..id = generateID()
        ..loaded = true
        ..done = false
        ..editable = true;
      Navigator.pop(context, widget.defaultHW);
    } else {
      CustomDialogs.showAnyDialog(context, "Remplissez tous les champs");
    }
  }

  processExistingHW() {
    if (widget.defaultHW != null) {
      disciplineNameTextController.text = widget.defaultHW?.discipline ?? "";
      contentTextController.text = widget.defaultHW?.rawContent ?? "";
      isATest = widget.defaultHW?.isATest ?? false;
      date = widget.defaultHW?.date ?? DateTime.now();
    }
  }
}
