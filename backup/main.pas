unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, code, unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ToggleBoxMain: TToggleBox;
    procedure Button1Click(Sender: TObject);
    procedure ToggleBoxMainChange(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ToggleBoxMainChange(Sender: TObject);
begin
  if ToggleBoxMain.Checked then
  begin
    ToggleBoxMain.Caption:='Gamemode Activated';
    ToggleBoxMain.Hint:='Click to disable Gamemode.';
    code.ActivateGamemode;
  end
  else
  begin
    ToggleBoxMain.Caption:='Activate Gamemode';
    ToggleBoxMain.Hint:='Click to activate Gamemode.';
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin

end;

end.

