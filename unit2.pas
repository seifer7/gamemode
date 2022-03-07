unit unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Grids, Variants, ComObj, ActiveX, ShellApi;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

const
  COL_IDX_KILL = 0;
  COL_IDX_PROC_NAME = 1;
  COL_IDX_PROC_PATH = 2;
  COL_IDX_PROC_CMDLINE = 3;
  COL_IDX_PROC_ID = 4;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Button1Click(Sender: TObject);
const
  wbemFlagForwardOnly = $00000020;

var
  FSWbemLocator: olevariant;
  FWMIService: olevariant;
  FWbemObjectSet: olevariant;
  FWbemObject: olevariant;
  oEnum: IEnumVariant;
  iValue: longword;
begin
  Form2.StringGrid1.FixedRows := 0;
  while Form2.StringGrid1.RowCount > 1 do Form2.StringGrid1.DeleteRow(0);
  Form2.StringGrid1.InsertRowWithValues(
    0, ['Kill', 'Process Name', 'Process Path', 'Command Line', 'Process ID']);
  Form2.StringGrid1.FixedRows := 1;

  CoInitialize(nil);
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  FWbemObjectSet := FWMIService.ExecQuery(
    'SELECT CommandLine, ExecutablePath, name, ProcessId FROM Win32_Process',
    'WQL', wbemFlagForwardOnly);
  oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    if not VarIsNull(FWbemObject.ExecutablePath) then
    begin
      Form2.StringGrid1.InsertRowWithValues(
        1, ['0', string(FWbemObject.Name), string(FWbemObject.ExecutablePath),
        string(FWbemObject.CommandLine), string(FWbemObject.ProcessId)]);
    end;
    FWbemObject := Unassigned; //avoid memory leak in oEnum.Next
  end;

end;

procedure TForm2.Button2Click(Sender: TObject);
var
  ProcessId: string;
  RowData: TStrings;
begin
  RowData := Form2.StringGrid1.Rows[Form2.StringGrid1.Row];
  ProcessId := RowData.ValueFromIndex[COL_IDX_PROC_ID];
  ShellExecute(0,'runas', PChar('taskkill'),PChar('/pid '+ProcessId+' /f'),nil,1);
end;

procedure TForm2.FormResize(Sender: TObject);
var
  AvailableWidth: integer;
begin
  Form2.StringGrid1.Width := Form2.Width;
  Form2.StringGrid1.Height := Form2.Height - Form2.StringGrid1.Top;
  AvailableWidth := Form2.StringGrid1.Width - (Form2.StringGrid1.ColWidths[COL_IDX_KILL] +
    Form2.StringGrid1.ColWidths[COL_IDX_PROC_ID]);
  Form2.StringGrid1.ColWidths[COL_IDX_PROC_NAME] := Trunc((AvailableWidth / 6) * 1);
  Form2.StringGrid1.ColWidths[COL_IDX_PROC_PATH] := Trunc((AvailableWidth / 6) * 2);
  Form2.StringGrid1.ColWidths[COL_IDX_PROC_CMDLINE] := Trunc((AvailableWidth / 6) * 3);
end;

end.
