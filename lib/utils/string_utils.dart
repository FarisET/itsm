String? capitalizeFirstLetter(String? text) {
  if (text == null)
    return null;
  else
    return text[0].toUpperCase() + text.substring(1);
}
