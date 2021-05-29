import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modalBottomSheets/dragHandle.dart';

Future<Homework?> showAddHomeworkBottomSheet(context, {Homework? hw}) {
  MediaQueryData screenSize = MediaQuery.of(context);

  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return AddHomeworkBottomSheet(
          defaultHW: hw,
        );
      });
}

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

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DragHandle(),
          SizedBox(
            height: screenSize.size.height / 10 * 0.1,
          ),
          Text(
            widget.defaultHW == null ? "Ajouter un nouveau devoir" : "Modifier un devoir existant",
            style:
                TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold, fontSize: 20),
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
          CustomButtons.materialButton(context, screenSize.size.width / 5 * 2.5, screenSize.size.height / 10 * 0.5,
              () async {
            process(context);
          },
              label: "J'ai fini",
              backgroundColor: (disciplineNameTextController.text != "" && contentTextController.text != "")
                  ? Colors.green
                  : Theme.of(context).primaryColorDark)
        ],
      ),
    );
  }

  Widget buildDateChoice() {
    String day = DateFormat("EEEE dd MMMM yyyy", "fr_FR").format(date).toUpperCase();
    var screenSize = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
      child: DateTimeFormField(
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ThemeUtils.textColor()),
          labelStyle: TextStyle(color: ThemeUtils.textColor()),
          counterStyle: TextStyle(color: ThemeUtils.textColor()),
          helperStyle: TextStyle(color: ThemeUtils.textColor()),
          prefixStyle: TextStyle(color: ThemeUtils.textColor()),
          suffixStyle: TextStyle(color: ThemeUtils.textColor()),
          errorStyle: TextStyle(color: Colors.redAccent),
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

  initState() {
    super.initState();
    processExistingHW();
  }

  process(BuildContext context) {
    if (disciplineNameTextController.text != "" && contentTextController.text != "") {
      Homework hw = Homework()
        ..date = date
        ..discipline = disciplineNameTextController.text
        ..disciplineCode = disciplineNameTextController.text.hashCode.toString()
        ..rawContent = contentTextController.text
        ..isATest = isATest
        ..dbId = widget.defaultHW?.dbId
        ..id = generateID()
        ..loaded = true
        ..done = false
        ..editable = true;
      Navigator.pop(context, hw);
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
