part of components;

class _ColorPickerDialog extends StatelessWidget {
  final YTColor? color;
  const _ColorPickerDialog({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = List.from(AppColors.colors);
    return YDialogBase(
      title: "Choisis une couleur",
      body: Center(
        child: Wrap(
          children: colors
              .map((e) => _Color(
                    color: e,
                    selectedColor: color,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _Color extends StatelessWidget {
  final YTColor color;
  final YTColor? selectedColor;
  const _Color({Key? key, required this.color, this.selectedColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedColor == color;
    return InkWell(
        onTap: () => Navigator.of(context).pop(isSelected ? null : color),
        child: Ink(
          color: isSelected ? color.lightColor.withOpacity(.2) : null,
          width: YScale.s24,
          height: YScale.s24,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: YBorderRadius.xl2,
                color: color.backgroundColor,
              ),
              width: YScale.s16,
              height: YScale.s16,
            ),
          ),
        ));
  }
}
