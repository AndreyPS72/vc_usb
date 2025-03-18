//------------------------------------------------------------------------------
// Дята последнего изменения: 24.05.2002
//------------------------------------------------------------------------------
unit LinkDefs;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

var

  EepromEnabled    : boolean   = false; //флаг, разрешающий меню програмирования eeprom прибора
  FlashEnabled     : boolean   = false; //флаг, разрешаюший меню програмирования flash прибора
  ClearDataEnabled : boolean   = false;

  hFileSave        : integer;
  Eeprom           : array[1..4096] of byte;  //буфер под eeprom
  EepromOffset     : integer;                 //вспомогательная переменная для считывания eeprom

  StopLink         : boolean  = false;


implementation 
end.
