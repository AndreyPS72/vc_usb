unit DefsPhaseTable;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses LinkTypes;


// Таблица с ФЧХ

const Atlant_MaxPointsPhaseShift    = 128;
const ID_Atlant_TablePhaseShift     = $50544149; // 'IATP' идентификатор T_Table_PhaseShift


Type T_PointPhaseShift = record
  Freq  : single;    // частота sin колебания
  Shift : single;    // сдвиг фаз в измерительном канале для частоты Freq
end;


Type T_Hdr_TablePhaseShift = record
    ID        : Longword;// идентификатор типа данных
    DataBytes : Longint; // количество данных для рассчета CRC от ID до последнего List[i] включительно ( =sizeof(Export_Table_PhaseShift) )
    Rsv0      : word;
    CRC       : TCRC; // контрольная сумма всего сообщения (зануляется перед расчетом)

    ver_hdr   : Byte; // версия заголовка
    ver_Point : Byte; // версия T_PointPhaseShift

    Points_Max: Byte; // число точек максимальное
    Points_N  : Byte; // число точек актуальных в таблице

    // Сдвиги для ФЧХ для каждого сигнала
    Points_Marker : LongInt; // Сдвиг в отсчётах до первого пика отметчика (в случае если был сдвинут в приборе, должен быть =0)
    Points_Phase  : LongInt; // Сдвиг в отсчётах по ФЧХ для первой гармоники (в случае если был сдвинут в приборе, должен быть <>0)
    Points_FREQ   : single;  // Длина одного периода в отсчётах. Используется для расчёта фазы в градусах (если =0 - нет сведений)

    Marker_Freq   : single; // регистрируемая прибором оборотная частота, Гц (если =0 - нет сведений)
    Signal_A1     : single; // амплитуда первой гармоники вещественная (канальные ед. измерения, ПИК)
    Signal_Ph1    : single; // фаза первой гармоники (град)

    iChannel  : Byte; // индекс канала внутриприборный

    // резерв
    Rsv1      : Byte;
    Rsv2      : word;
    Rsv3      : Longword;
end;

Type P_Table_PhaseShift = ^T_Table_PhaseShift;
    T_Table_PhaseShift = record
  HDR   : T_Hdr_TablePhaseShift; // заголовок калибровочной таблицы внутриприборного сдвига фаз
  List  : array [0..Atlant_MaxPointsPhaseShift-1] of T_PointPhaseShift; // список калибровочных точек
end;

const szT_Table_PhaseShift = SizeOf(T_Table_PhaseShift);



implementation

end.
 
