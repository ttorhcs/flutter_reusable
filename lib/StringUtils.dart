bool stringNotEmpty(String string){
  return string != null && string.trim().length > 0;
}

bool stringEmpty(String string){
  return !stringNotEmpty(string);
}