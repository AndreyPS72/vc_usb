unit LinkLang;

{$MODE DelphiUnicode}
{$CODEPAGE UTF8}
{$H+}

interface
uses LCLTranslator;

resourcestring

      MenuFileCaption            = 'Файл';
      ItemExitCaption            = 'Выход';
      MenuSetupCaption           = 'Настройки';
      ItemInterfaceSetupCaption  = 'Настройки связи';
      ItemInterfaceSaveToFile	 = 'Сохранить в файлы';
      MenuHelpCaption            = 'Помощь';
      ItemContenstCaption        = 'Содержание';
      ItemHelpWorkCaption        = 'Работа с программой';
      BoxPriborParametersCaption = 'Параметры прибора';
      BoxListZamerCaption        = 'Список замеров';
      BtnTestCaption             = 'Установить'+#13+'связь';
      BtnExitCaption             = 'Выход';
      BtnLoadCaption             = 'Считать'+#13+'данные';
      BtnStopCaption             = 'Остановить'+#13+'считывание';
      BtnSaveCaption             = 'Сохранить'+#13+'замеры';
      DirectorySelected		 = 'Выбрана загрузка из файлов. Выбрать USB-порт ?';
      FlashSavedCaption          = 'Все данные сохранены в каталог';
      DirectoryCaption           = 'Каталог';

      PriborName                 = 'Наименование прибора';
      PriborSerial               = 'Серийный номер прибора';
      PriborProgVersion          = 'Версия програмного обеспечения';
      PriborLinkVersion          = 'Версия протокола обмена';
      PriborFlash                = 'Размер FLASH';
      PriborEeprom               = 'Размер EEPROM';
      LinkErrorComPort           = 'Прибор не обнаружен ! Проверте правильность выбора COM порта. Проверте, что прибор подключен к компьютеру, включен и установлен в режим разгрузки данных';
      LinkErrorLptPort           = 'Прибор не обнаружен ! Проверте правильность выбора LPT порта. Проверте, что прибор подключен к компьютеру, включен и установлен в режим разгрузки данных';
      LinkErrorUSBPort           = 'Прибор не обнаружен !';
      ErrorOpenComPort           = 'Ошибка при открытии COM порта ! Выбранный COM порт не может быть использован для связи с прибором';
      ErrorOpenLptPort           = 'Ошибка при открытии LPT порта ! Выбранный LPT порт не может быть использован для связи с прибором';
      ErrorOpenUSBPort           = 'Ошибка при открытии USB порта !';
      ErrorVersionUp             = 'Версия протокола обмена %s не поддерживается данной программы.'+#13#10+'Пожалуйста обновите программу';
      ErrorVersionDown           = 'Версия протокола обмена %s не поддерживается данной программы. Пожалуйста обновите версию прошивки прибора или вернитесь к старой версии программы';
      ErrorListTypeData          = 'Неизвестен тип считываемых данных. Считать список замеров невозможно';
      ErrorNoZamer               = 'Нет ни одного замера в приборе !';
      ErrorNoLinkData            = 'Нет данных для считывания';
      DataAlreadyRead            = 'Данные (%d из %d) были уже считаны ! Считать эти данные снова ?';
      DialogClose                = 'Закончить работу со связью ?';
      LinkNoUsb                  = 'Связь с приборами по USB не поддерживается в данной версии программы';
      MainCaption                = 'Связь';
      MainCaptionCom             = 'Связь (Порт:%s, Скорость:%s)';
      MainCaptionLpt             = 'Связь (Порт:%s)';
      MainCaptionUSB             = 'Связь (Порт:USB)';

      ReadingZamerList           = 'Считывание списка замеров...';

      ReadingZamerListNo         = 'Функция считывания списка замеров не подключена для данного прибора';
      ReadingZamerTime           = 'Время считывания замеров - ';

      ProgramFlash               = 'Програмирование Flash';
      ProgramFlashOk             = 'Flash запрограмирован...';

  MainFuncWait            ='Ждите...';
  MainFuncSearchPribor    =' Поиск прибора ';
  MainFuncLoad            ='Загрузка';
  MainFuncSearchRoute     =' Поиск маршрута ';
  MainFuncLoadRoute       ='Загрузка маршрута';
  MainFuncLoadHeaderRoute ='Загрузка заголовка маршрута...';
  MainFuncLoadDataRoute   ='Загрузка данных маршрута...';


  RouteDownloadStatus               = ' Статус ';
  RouteDownloadErrorProtokol        = 'Данная функция реализована только для приборов Диана-8, Диана-2М,'+#13#10+'Диана-С, Vibro Vision-2, Viana-1, Viana-4 и Вик-3.'+#13#10+'Для того чтобы скачать маршрут выберите соответствующий прибор.';
  RouteDownloadInternalErrorLibrary = 'Внутренняя ошибка библиотеки связи с прибором.';
  RouteDownloadEditNameAgregat      = 'Исправить имя агрегата';
  RouteDownloadPort                 = 'Порт:';
  RouteDownloadPortUSB              = 'USB';
  RouteDownloadPortCOM              = 'COM';
  RouteDownloadPortLPT              = 'LPT';
  RouteDownloadPortEthernet         = 'Ethernet';

  RouteDownloadFormCaption          = 'Выгрузка замеров по маршруту';
  RouteDownloadBtnChangeCantion     = 'Изменить';
  RouteDownloadInterface            = 'Интерфейс';

  RouteUploadErrorLoadEmptyRoute = 'Невозможно загрузить в прибор пустой маршрут';
  RouteUploadSearchPribor        = ' Поиск прибора ';
  RouteUploadErrorProtokol       = 'Данная функция реализована только для приборов Диана-8, Диана2М, Диана-С, Vibro Vision-2 и Вик-3.'+#13#10+'Для того чтобы закачать маршрут выберите соответствующий прибор.';
  RouteUploadLoadCaptionRoute    = ' Загрузка заголовка маршрута ';
  RouteUploadRouteExist          = 'Маршрут с именем "%s" уже существует в приборе.'+#13#10+'Желаете его перезаписать?';
  RouteUploadDeleteRoute         = ' Удаление маршрута ';
  RouteUploadErrorDeleteRoute    = 'Ошибка при удалении маршрута';
  RouteUploadLoadPoint           = ' Загружено точек (%d/%d)';
  RouteUploadErrorLoadPoint      = 'Ошибка при загрузке точки маршрута #%d';
  RouteUploadRouteLoadOk         = 'Маршрут с именем "%s" успешно закачан в прибор';
  RouteUploadErrorStruct         = 'Обнаружена ошибка в маршруте с именем "%s". Пожалуйста исправте ее или пересоздайте маршрут заново.';

  RouteUploadFormCaption         = 'Загрузка маршрута в прибор';

  LinkUtilSignal = 'Сигнал';
  LinkUtilZamer = 'Замер';
  LinkUtilConfig = 'Config';
  LinkUtilStat = 'Статистика';
  LinkUtilImpulse = 'Импульс';
  LinkUtilTrial = 'Испытание';
  LinkUtilPower = 'Ватметрграмма';
  LinkUtilRoute = 'Маршрут';
  LinkUtilRazgon = 'Разгон-выбег';
  LinkUtilDSP = 'DSP';
  LinkUtilImage = 'Картинка';
  LinkUtilZAmerRMS = 'Замер с СКЗ';
  LinkUtilTypeW = 'Мощность';
  LinkUtilTypeI = 'Ток';
  LinkUtilTypeMPT = 'МПТ';
  LinkUtilVoltage = 'Напряжение';
  LinkUtilCurrent = 'Ток';


  LinkUtilDataVibrometer = 'Данные виброметра';
  ErrorInternalStr = 'Внутренняя ошибка программы';
  ErrorOkStr = 'Операция выполнена успешно';
  ErrorLoadHeaderRouteStr = 'Ошибка при загрузке заголовка маршрута';
  ErrorLoadPointRouteStr = 'Ошибка при загрузке точки маршрута';
  ErrorLenNameRouteStr = 'Неправильная длина имени маршрута';
  ErrorInitDbfFileStr = 'Ошибка при инициализации DBF файла';
  ErrorFileRouteStr = 'Ошибка при чтении файла маршрута';
  ErrorRouteCRCStr = 'Ошибка CRC в заголовке маршрута';
  ErrorPointCRCStr = 'Ошибка CRC в заголовке точки маршрута';
  ErrorLoadPointStr = 'Ошибка при считывании данных по точке маршрута';
  ErrorTmpFileRouteStr = 'Не могу найти временный файл маршрута';
  ErrorLenFreqStr = 'Неправильно задано кол-во граничных частот для точки маршрута';
  ErrorValueFreqStr = 'Неправильное задано значение граничной частоты для точки маршрута';
  ErrorSearchPriborStr = 'Прибор не найден';
  ErrorInitPortStr = 'Ошибка при инициализации порта';
  ErrorDataReadStr = 'Ошибка при чтении данных';
  ErrorCreateTmpFileStr = 'Ошибка при создании временного файла';
  ErrorCRCStr = 'Ошибка при расчете контрольной суммы';
  ErrorClearDataStr = 'Ошибка при очистке памяти прибора';
  ErrorPathIniFileStr = 'Не могу найти ini-файл';
  ErrorIOIniFileStr = 'Ошибка ввода/вывода при работе с ini-файлом';
  ErrorDeleteTmpFileStr = 'Ошибка при удалении временного файла';
  ErrorLinkStopingStr = 'Операция остановлена пользователем';
  ErrorSearchRouteStr = 'Маршрут не найден';
  ErrorDeviceNotRespondedStr = 'Прибор не отвечает';
  ErrorDownloadLinkListStr = 'Ошибка при считывании списока замеров';
  ErrorLinkListEmptyStr = 'Список замеров пуст';
  ErrorReadBreakUserStr = 'Считывание прервано пользователем';
  ErrorSecondReadBreakUserStr = 'Повторное считывание отменено пользователем';
  ErrorCreateTempDirStr = 'Ошибка при создании временной папки';
  ErrorCreateTempFileStr = 'Ошибка при создании временного файла';
  ErrorProcessingDataStr = 'Ошибка при обработке данных';
  ErrorFunctionReadingStr = 'Не определена функция для считывания данных';
  ErrorDataAlreadyReadingStr = 'Данные уже считаны';
  ErrorInitDriverLPTStr = 'Ошибка при инициализации драйвера LPT порта';
  ErrorInitDriverUSBStr = 'Ошибка при инициализации драйвера USB порта';
  ErrorInitAddrLPTStr = 'Не могу найти базовый адрес LTP порта';
  ErrorCreateClassStr = 'Ошибка при создании объекта ImportDlg';
  ErrorClassAlreadyExistStr = 'Объект ImportDlg уже существует';
  ErrorReadRouteFunctionStr = 'Не определена функция для считывания маршрута';
  ErrorTransRouteFunctionStr = 'Неопределена функция для трансляции маршрута';
  ErrorUnknownStr = 'Неизвестная ошибка';

  prDianaStr = 'Диана-2';
  prKorsarStr = 'Корсар';
  prAMTest2Str = 'AMTest2';
  prNiktaStr = 'Никта';
  prR2000Str = 'R2000';
  prTestSKStr = 'Test-SK';
  prTestSKRev2Str = 'Test-SK (v2.0)';
  prVik3Str = 'Вик-Антес';
  prVik3Rev1Str = 'Вик-3';
  prDiana8Str = 'Диана 8';
  prDiana2Rev1Str = 'Диана-2М';
  prDiana2Rev2Str = 'Диана-2М';
  prDiana8Rev1Str = 'Диана-8';
  prR400Str = 'R400 (Кабельный индикатор)';
  prKorsarROSStr = 'Корсар (центровка)';
  prAR700Str = 'AR700';
  prAR700Rev2Str = 'AR700 (v2.0)';
  prDianaSStr = 'Диана С';
  prGanimedStr = 'Ганимед';
  prCLTesterStr = 'CL-Tester';
  prAR200Str = 'AR200';
  prAR100Str = 'AR100';
  prBalansSKStr = 'Баланс-СК2';
  prUltraTestStr = 'UltraTest';
  prViana1Str = 'Viana-1';
  prViana4Str = 'Viana-4';
  prVS3DStr = 'VS-3D';
  prVV2Str = 'Vibro Vision-2';
  prDPKStr = 'ДПК-Вибро';
  prViana2Str = 'Viana-2';
  prUnknownStr = 'Неизвестный прибор';

      LoadDlgCaptionLoading      = 'Загрузка (%d/%d)';
      LoadDlgLabelListOk         = 'Список считан...';
      LoadDlgCaptionSearch       = 'Поиск прибора';
      LoadDlgLabelSearch         = 'Ждите...Идет поиск прибора...';
      LoadDlgLabelWiat           = 'Ждите...';
      LoadDlgCaptionComplete     = 'считан...';
      LoadDlgLabelLoadRoute      = 'Загрузка данных маршрута';
      LoadDlgCaptionPoint        = 'Точка (%d/%d)';
      LoadDlgLoadRoute           = 'Чтение маршрута';
      LoadDlgLoadRoutePoint      = 'Чтение точек маршрута (%d/%d)';

      DateAtStr                      = 'от';
      TimeInStr                      = 'в ';

   ErrorZamerNoSave       = 'Замеры, cчитанные с прибора, не были сохранены в базе данных программы !'+#10+'Желаете сохранить замеры ?';
   ErrorDataRazgon        = 'Ошибка в данных Разгон-Выбега';
   ErrorCreateFileRazgon  = 'Ошибка при создании файла Разгон-Выбег';

    LinkProtokolMarker     = 'отметчик';



    InterfaceSetupDlgCaption   = 'Настройки';
    Page1Caption               = 'Настройки связи';
    Page2Caption               = 'Общие';
    PortGroupCaption           = 'Тип порта';
    ComGroupCaption            = 'COM Порт';
    LptGroupCaption            = 'LPT Порт';
    LabelCountRepeatCaption    = 'Число повторов';
    LabelIPCaption             = 'IP адрес';



implementation
uses    IniFiles;

(*
procedure LoadLang();
var
  ini:TMemIniFile;
begin
   ini:=TMemIniFile.Create('.\link.lng');


    PriborName                   := ini.ReadString('MainForm','PriborName',PriborName);
    PriborSerial                 := ini.ReadString('MainForm','PriborSerial',PriborSerial);
    PriborProgVersion            := ini.ReadString('MainForm','PriborProgVersion',PriborProgVersion);
    PriborLinkVersion            := ini.ReadString('MainForm','PriborLinkVersion',PriborLinkVersion);
    PriborFlash                  := ini.ReadString('MainForm','PriborFlash',PriborFlash);
    PriborEeprom                 := ini.ReadString('MainForm','PriborEeprom',PriborEeprom);
    LinkErrorComPort             := ini.ReadString('MainForm','LinkErrorComPort',LinkErrorComPort);
    LinkErrorLptPort             := ini.ReadString('MainForm','LinkErrorLptPort',LinkErrorLptPort);
    LinkErrorUSBPort             := ini.ReadString('MainForm','LinkErrorUSBPort',LinkErrorUSBPort);
    ErrorOpenComPort             := ini.ReadString('MainForm','ErrorOpenComPort',ErrorOpenComPort);
    ErrorOpenLptPort             := ini.ReadString('MainForm','ErrorOpenLptPort',ErrorOpenLptPort);
    ErrorOpenUSBPort             := ini.ReadString('MainForm','ErrorOpenUSBPort',ErrorOpenUSBPort);
    ErrorVersionUp               := ini.ReadString('MainForm','ErrorVersionUp',ErrorVersionUp);
    ErrorVersionDown             := ini.ReadString('MainForm','ErrorVersionDown',ErrorVersionDown);
    ErrorListTypeData            := ini.ReadString('MainForm','ErrorListTypeData',ErrorListTypeData);
    ErrorNoZamer                 := ini.ReadString('MainForm','ErrorNoZamer',ErrorNoZamer);
    ErrorNoLinkData              := ini.ReadString('MainForm','ErrorNoLinkData',ErrorNoLinkData);
    DataAlreadyRead              := ini.ReadString('MainForm','DataAlreadyRead',DataAlreadyRead);
    DialogClose                  := ini.ReadString('MainForm','DialogClose',DialogClose);
    LinkNoUsb                    := ini.ReadString('MainForm','LinkNoUsb',LinkNoUsb);
    MainCaption                  := ini.ReadString('MainForm','MainCaption',MainCaption);
    MainCaptionCom               := ini.ReadString('MainForm','MainCaptionCom',MainCaptionCom);
    MainCaptionLpt               := ini.ReadString('MainForm','MainCaptionLpt',MainCaptionLpt);
    MainCaptionUSB               := ini.ReadString('MainForm','MainCaptionUSB',MainCaptionUSB);
    AtStr                        := ini.ReadString('MainForm','AtStr',AtStr);
    InStr                        := ini.ReadString('MainForm','InStr',InStr);

    ReadingZamerList             := ini.ReadString('LoadDlg','ReadingZamerList',ReadingZamerList);
    LoadDlgCaptionLoading        := ini.ReadString('LoadDlg','LoadDlgCaptionLoading',LoadDlgCaptionLoading);
    LoadDlgLabelListOk           := ini.ReadString('LoadDlg','LoadDlgLabelListOk',LoadDlgLabelListOk);
    LoadDlgCaptionSearch         := ini.ReadString('LoadDlg','LoadDlgCaptionSearch',LoadDlgCaptionSearch);
    LoadDlgLabelSearch           := ini.ReadString('LoadDlg','LoadDlgLabelSearch',LoadDlgLabelSearch);
    LoadDlgLabelWiat             := ini.ReadString('LoadDlg','LoadDlgLabelWiat',LoadDlgLabelWiat);
    LoadDlgCaptionComplete       := ini.ReadString('LoadDlg','LoadDlgCaptionComplete',LoadDlgCaptionComplete);
    LoadDlgLabelLoadRoute        := ini.ReadString('LoadDlg','LoadDlgLabelLoadRoute',LoadDlgLabelLoadRoute);
    LoadDlgCaptionPoint          := ini.ReadString('LoadDlg','LoadDlgCaptionPoint',LoadDlgCaptionPoint);
    LoadDlgLoadRoute             := ini.ReadString('LoadDlg','LoadDlgLoadRoute',LoadDlgLoadRoute);
    LoadDlgLoadRoutePoint        := ini.ReadString('LoadDlg','LoadDlgLoadRoutePoint',LoadDlgLoadRoutePoint);

    ReadingZamerListNo           := ini.ReadString('MainForm','ReadingZamerListNo',ReadingZamerListNo);
    ReadingZamerTime             := ini.ReadString('MainForm','ReadingZamerTime',ReadingZamerTime);
    ProgramFlash                 := ini.ReadString('MainForm','ProgramFlash',ProgramFlash);
    ProgramFlashOk               := ini.ReadString('MainForm','ProgramFlashOk',ProgramFlashOk);

  MainFuncWait            := ini.ReadString('MainFunc','MainFuncWait',MainFuncWait);
  MainFuncSearchPribor    := ini.ReadString('MainFunc','MainFuncSearchPribor',MainFuncSearchPribor);
  MainFuncLoad            := ini.ReadString('MainFunc','MainFuncLoad',MainFuncLoad);
  MainFuncSearchRoute     := ini.ReadString('MainFunc','MainFuncSearchRoute',MainFuncSearchRoute);
  MainFuncLoadRoute       := ini.ReadString('MainFunc','MainFuncLoadRoute',MainFuncLoadRoute);
  MainFuncLoadHeaderRoute := ini.ReadString('MainFunc','MainFuncLoadHeaderRoute',MainFuncLoadHeaderRoute);
  MainFuncLoadDataRoute   := ini.ReadString('MainFunc','MainFuncLoadDataRoute',MainFuncLoadDataRoute);


  RouteDownloadStatus               := ini.ReadString('RouteDownload','RouteDownloadStatus',RouteDownloadStatus);
  RouteDownloadErrorProtokol        := ini.ReadString('RouteDownload','RouteDownloadErrorProtokol',RouteDownloadErrorProtokol);
  RouteDownloadInternalErrorLibrary := ini.ReadString('RouteDownload','RouteDownloadInternalErrorLibrary',RouteDownloadInternalErrorLibrary);
  RouteDownloadEditNameAgregat      := ini.ReadString('RouteDownload','RouteDownloadEditNameAgregat',RouteDownloadEditNameAgregat);
  RouteDownloadPort                 := ini.ReadString('RouteDownload','RouteDownloadPort',RouteDownloadPort);
  RouteDownloadPortUSB              := ini.ReadString('RouteDownload','RouteDownloadPortUSB',RouteDownloadPortUSB);
  RouteDownloadPortCOM              := ini.ReadString('RouteDownload','RouteDownloadPortCOM',RouteDownloadPortCOM);
  RouteDownloadPortLPT              := ini.ReadString('RouteDownload','RouteDownloadPortLPT',RouteDownloadPortLPT);
  RouteDownloadPortEthernet         := ini.ReadString('RouteDownload','RouteDownloadPortEthernet',RouteDownloadPortEthernet);
  RouteDownloadFormCaption          := ini.ReadString('RouteDownload','RouteDownloadFormCaption',RouteDownloadFormCaption);
  RouteDownloadBtnChangeCantion     := ini.ReadString('RouteDownload','RouteDownloadBtnChangeCantion',RouteDownloadBtnChangeCantion);
  RouteDownloadInterface            := ini.ReadString('RouteDownload','RouteDownloadInterface',RouteDownloadInterface);

  RouteUploadErrorLoadEmptyRoute := ini.ReadString('RouteUpload','RouteUploadErrorLoadEmptyRoute',RouteUploadErrorLoadEmptyRoute);
  RouteUploadSearchPribor        := ini.ReadString('RouteUpload','RouteUploadSearchPribor',RouteUploadSearchPribor);
  RouteUploadErrorProtokol       := ini.ReadString('RouteUpload','RouteUploadErrorProtokol',RouteUploadErrorProtokol);
  RouteUploadLoadCaptionRoute    := ini.ReadString('RouteUpload','RouteUploadLoadCaptionRoute',RouteUploadLoadCaptionRoute);
  RouteUploadRouteExist          := ini.ReadString('RouteUpload','RouteUploadRouteExist',RouteUploadRouteExist);
  RouteUploadDeleteRoute         := ini.ReadString('RouteUpload','RouteUploadDeleteRoute',RouteUploadDeleteRoute);
  RouteUploadErrorDeleteRoute    := ini.ReadString('RouteUpload','RouteUploadErrorDeleteRoute',RouteUploadErrorDeleteRoute);
  RouteUploadLoadPoint           := ini.ReadString('RouteUpload','RouteUploadLoadPoint',RouteUploadLoadPoint);
  RouteUploadErrorLoadPoint      := ini.ReadString('RouteUpload','RouteUploadErrorLoadPoint',RouteUploadErrorLoadPoint);
  RouteUploadRouteLoadOk         := ini.ReadString('RouteUpload','RouteUploadRouteLoadOk',RouteUploadRouteLoadOk);
  RouteUploadErrorStruct         := ini.ReadString('RouteUpload','RouteUploadErrorStruct',RouteUploadErrorStruct);

  RouteUploadFormCaption         := ini.ReadString('RouteUpload','RouteUploadFormCaption',RouteUploadFormCaption);


   ErrorZamerNoSave:=ini.ReadString('LinkProtokol','ErrorZamerNoSave',ErrorZamerNoSave);

   ErrorDataRazgon:=ini.ReadString('LinkProtokol','ErrorDataRazgon',ErrorDataRazgon);
   ErrorCreateFileRazgon:=ini.ReadString('LinkProtokol','ErrorCreateFileRazgon',ErrorCreateFileRazgon);
   ErrorZamerNoSave:=ini.ReadString('LinkProtokol','ErrorZamerNoSave',ErrorZamerNoSave);
   LinkProtokolMarker:=ini.ReadString('LinkProtokol','LinkProtokolMarker',LinkProtokolMarker);


  LinkUtilSignal:=ini.ReadString('LinkUtil','LinkUtilSignal',LinkUtilSignal);
  LinkUtilZamer:=ini.ReadString('LinkUtil','LinkUtilZamer',LinkUtilZamer);
  LinkUtilDataVibrometer:=ini.ReadString('LinkUtil','LinkUtilDataVibrometer',LinkUtilDataVibrometer);
  LinkUtilConfig:=ini.ReadString('LinkUtil','LinkUtilConfig',LinkUtilConfig);
  LinkUtilStat:=ini.ReadString('LinkUtil','LinkUtilStat',LinkUtilStat);
  LinkUtilImpulse:=ini.ReadString('LinkUtil','LinkUtilImpulse',LinkUtilImpulse);
  LinkUtilTrial:=ini.ReadString('LinkUtil','LinkUtilTrial',LinkUtilTrial);
  LinkUtilPower:=ini.ReadString('LinkUtil','LinkUtilPower',LinkUtilPower);
  LinkUtilRoute:=ini.ReadString('LinkUtil','LinkUtilRoute',LinkUtilRoute);
  LinkUtilRazgon:=ini.ReadString('LinkUtil','LinkUtilRazgon',LinkUtilRazgon);
  LinkUtilDSP:=ini.ReadString('LinkUtil','LinkUtilDSP',LinkUtilDSP);
  LinkUtilImage:=ini.ReadString('LinkUtil','LinkUtilImage',LinkUtilImage);
  LinkUtilZAmerRMS:=ini.ReadString('LinkUtil','LinkUtilZAmerRMS',LinkUtilZAmerRMS);
  LinkUtilTypeW:=ini.ReadString('LinkUtil','LinkUtilTypeW',LinkUtilTypeW);
  LinkUtilTypeI:=ini.ReadString('LinkUtil','LinkUtilTypeI',LinkUtilTypeI);
  LinkUtilTypeMPT:=ini.ReadString('LinkUtil','LinkUtilTypeMPT',LinkUtilTypeMPT);
  LinkUtilVoltage:=ini.ReadString('LinkUtil','LinkUtilVoltage',LinkUtilVoltage);
  LinkUtilCurrent:=ini.ReadString('LinkUtil','LinkUtilCurrent',LinkUtilCurrent);

  ErrorInternalStr:=ini.ReadString('LinkUtil','ErrorInternalStr',ErrorInternalStr);
  ErrorOkStr:=ini.ReadString('LinkUtil','ErrorOkStr',ErrorOkStr);
  ErrorLoadHeaderRouteStr:=ini.ReadString('LinkUtil','ErrorLoadHeaderRouteStr',ErrorDeleteTmpFileStr);
  ErrorLoadPointRouteStr:=ini.ReadString('LinkUtil','ErrorLoadPointRouteStr',ErrorLoadPointRouteStr);
  ErrorLenNameRouteStr:=ini.ReadString('LinkUtil','ErrorLenNameRouteStr',ErrorLenNameRouteStr);
  ErrorInitDbfFileStr:=ini.ReadString('LinkUtil','ErrorInitDbfFileStr',ErrorInitDbfFileStr);
  ErrorFileRouteStr:=ini.ReadString('LinkUtil','ErrorFileRouteStr',ErrorFileRouteStr);
  ErrorPointCRCStr:=ini.ReadString('LinkUtil','ErrorPointCRCStr',ErrorPointCRCStr);
  ErrorRouteCRCStr:=ini.ReadString('LinkUtil','ErrorRouteCRCStr',ErrorRouteCRCStr);
  ErrorLoadPointStr:=ini.ReadString('LinkUtil','ErrorLoadPointStr',ErrorLoadPointStr);
  ErrorTmpFileRouteStr:=ini.ReadString('LinkUtil','ErrorTmpFileRouteStr',ErrorTmpFileRouteStr);
  ErrorLenFreqStr:=ini.ReadString('LinkUtil','ErrorLenFreqStr',ErrorLenFreqStr);
  ErrorValueFreqStr:=ini.ReadString('LinkUtil','ErrorValueFreqStr',ErrorValueFreqStr);
  ErrorSearchPriborStr:=ini.ReadString('LinkUtil','ErrorSearchPriborStr',ErrorSearchPriborStr);
  ErrorInitPortStr:=ini.ReadString('LinkUtil','ErrorInitPortStr',ErrorInitPortStr);
  ErrorDataReadStr:=ini.ReadString('LinkUtil','ErrorDataReadStr',ErrorDataReadStr);
  ErrorCreateTmpFileStr:=ini.ReadString('LinkUtil','ErrorCreateTmpFileStr',ErrorCreateTmpFileStr);
  ErrorCRCStr:=ini.ReadString('LinkUtil','ErrorCRCStr',ErrorCRCStr);
  ErrorClearDataStr:=ini.ReadString('LinkUtil','ErrorClearDataStr',ErrorClearDataStr);
  ErrorPathIniFileStr:=ini.ReadString('LinkUtil','ErrorPathIniFileStr',ErrorPathIniFileStr);
  ErrorIOIniFileStr:=ini.ReadString('LinkUtil','ErrorIOIniFileStr',ErrorIOIniFileStr);
  ErrorDeleteTmpFileStr:=ini.ReadString('LinkUtil','ErrorDeleteTmpFileStr',ErrorDeleteTmpFileStr);
  ErrorLinkStopingStr:=ini.ReadString('LinkUtil','ErrorLinkStopingStr',ErrorLinkStopingStr);
  ErrorSearchRouteStr:=ini.ReadString('LinkUtil','ErrorSearchRouteStr',ErrorSearchRouteStr);
  ErrorDeviceNotRespondedStr:=ini.ReadString('LinkUtil','ErrorDeviceNotRespondetStr',ErrorDeviceNotRespondedStr);
  ErrorDownloadLinkListStr:=ini.ReadString('LinkUtil','ErrorDownloadLinkListStr',ErrorDownloadLinkListStr);
  ErrorLinkListEmptyStr:=ini.ReadString('LinkUtil','ErrorLinkListEmptyStr',ErrorLinkListEmptyStr);
  ErrorReadBreakUserStr:=ini.ReadString('LinkUtil','ErrorReadBreakUserStr',ErrorReadBreakUserStr);
  ErrorSecondReadBreakUserStr:=ini.ReadString('LinkUtil','ErrorSecondReadBreakUserStr',ErrorSecondReadBreakUserStr);
  ErrorCreateTempDirStr:=ini.ReadString('LinkUtil','ErrorCreateTempDirStr',ErrorCreateTempDirStr);
  ErrorCreateTempFileStr:=ini.ReadString('LinkUtil','ErrorCreateTempFileStr',ErrorCreateTempFileStr);
  ErrorCreateTempFileStr:=ini.ReadString('LinkUtil','ErrorProcessingDataStr',ErrorCreateTempFileStr);
  ErrorFunctionReadingStr:=ini.ReadString('LinkUtil','ErrorFunctionReadingStr',ErrorFunctionReadingStr);
  ErrorDataAlreadyReadingStr:=ini.ReadString('LinkUtil','ErrorDataAlreadyReadingStr',ErrorDataAlreadyReadingStr);
  ErrorInitDriverLPTStr:=ini.ReadString('LinkUtil','ErrorInitDriverLPTStr',ErrorInitDriverLPTStr);
  ErrorInitDriverUSBStr:=ini.ReadString('LinkUtil','ErrorInitDriverUSBStr',ErrorInitDriverUSBStr);
  ErrorInitAddrLPTStr:=ini.ReadString('LinkUtil','ErrorInitAddrLPTStr',ErrorInitAddrLPTStr);
  ErrorCreateClassStr:=ini.ReadString('LinkUtil','ErrorCreateClassStr',ErrorCreateClassStr);
  ErrorClassAlreadyExistStr:=ini.ReadString('LinkUtil','ErrorClassAlreadyExistStr',ErrorClassAlreadyExistStr);
  ErrorReadRouteFunctionStr:=ini.ReadString('LinkUtil','ErrorReadRouteFunctionStr',ErrorReadRouteFunctionStr);
  ErrorTransRouteFunctionStr:=ini.ReadString('LinkUtil','ErrorTransRouteFunctionStr',ErrorTransRouteFunctionStr);
  ErrorUnknownStr:=ini.ReadString('LinkUtil','ErrorUnknownStr',ErrorUnknownStr);

  prDianaStr:=ini.ReadString('LinkUtil','prDianaStr',prDianaStr);
  prKorsarStr:=ini.ReadString('LinkUtil','prKorsarStr',prKorsarStr);
  prNiktaStr:=ini.ReadString('LinkUtil','prNiktaStr',prKorsarStr);
  prR2000Str:=ini.ReadString('LinkUtil','prR2000Str',prR2000Str);
  prTestSKStr:=ini.ReadString('LinkUtil','prTestSKStr',prTestSKStr);
  prTestSKRev2Str:=ini.ReadString('LinkUtil','prTestSK2Str',prTestSKRev2Str);
  prVik3Str:=ini.ReadString('LinkUtil','prVik3Str',prVik3Str);
  prVik3Rev1Str:=ini.ReadString('LinkUtil','prVik3Rev1Str',prVik3Rev1Str);
  prDiana8Str:=ini.ReadString('LinkUtil','prDiana8Str',prDiana8Str);
  prDiana2Rev1Str:=ini.ReadString('LinkUtil','prDiana2Rev1Str',prDiana2Rev1Str);
  prDiana2Rev2Str:=ini.ReadString('LinkUtil','prDiana2Rev2Str',prDiana2Rev2Str);
  prDiana8Rev1Str:=ini.ReadString('LinkUtil','prDiana8Rev1Str',prDiana8Rev1Str);
  prR400Str:=ini.ReadString('LinkUtil','prR400Str',prR400Str);
  prKorsarROSStr:=ini.ReadString('LinkUtil','prKorsarROSStr',prKorsarROSStr);
  prAR700Str:=ini.ReadString('LinkUtil','prAR700Str',prAR700Str);
  prAR700Rev2Str:=ini.ReadString('LinkUtil','prAR700Rev2Str',prAR700Rev2Str);
  prDianaSStr:=ini.ReadString('LinkUtil','prDianaSStr',prDianaSStr);
  prGanimedStr:=ini.ReadString('LinkUtil','prGanimedStr',prGanimedStr);
  prCLTesterStr:=ini.ReadString('LinkUtil','prCLTester',prCLTesterStr);
  prAR200Str:=ini.ReadString('LinkUtil','prAR200',prAR200Str);
  prAR100Str:=ini.ReadString('LinkUtil','prAR100',prAR100Str);
  prBalansSKStr:=ini.ReadString('LinkUtil','prBalansSK',prBalansSKStr);
  prVV2Str:=ini.ReadString('LinkUtil','prVV2Str',prVV2Str);
  prViana2Str:=ini.ReadString('LinkUtil','prViana2Str',prViana2Str);
  prUnknownStr:=ini.ReadString('LinkUtil','prUnknownStr',prUnknownStr);


    ini.Destroy;
end;
*)


initialization
//    LoadLang();
end.
