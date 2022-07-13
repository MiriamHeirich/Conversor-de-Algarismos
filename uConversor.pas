unit uConversor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmConversor = class(TForm)
    pnlCentral: TPanel;
    lblCardinal: TLabel;
    lblRomano: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    edtCardinal: TEdit;
    edtRomano: TEdit;
    btnConverter: TBitBtn;
    btnFechar: TBitBtn;
    Edit1: TEdit;
    editCardinal: TEdit;
    btnReverter: TBitBtn;
    pnlTopo: TPanel;
    Image1: TImage;
    edtConverter: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    BalloonHint1: TBalloonHint;
    procedure btnConverterClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnReverterClick(Sender: TObject);
    procedure edtRomanoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
     function cardinalParaRomano(Decimal: Integer): string;
     function RomanoParaCardinal(const S: string): integer;
  end;

var
  frmConversor: TfrmConversor;

implementation

{$R *.dfm}

{ TfrmConversor }

procedure TfrmConversor.btnConverterClick(Sender: TObject);
begin
  edtRomano.Text := cardinalParaRomano(strtoint(editCardinal.Text));
end;

procedure TfrmConversor.btnFecharClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmConversor.btnReverterClick(Sender: TObject);
begin
   var
algarismosRomanos : string;
begin
algarismosRomanos := edtRomano.Text;

 edtConverter.Text := romanoParaCardinal(algarismosRomanos).ToString;
end;
end;

function TfrmConversor.cardinalParaRomano(Decimal: Integer): string;
const

  Romans: array[1..13] of string = ( 'I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C', 'CD', 'D', 'CM', 'M' );

  Arabics: array[1..13] of Integer = ( 1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);

var

  i: Integer;

  scratch: string;

begin

  scratch := '';

  for i := 13 downto 1 do

    while ( Decimal >= Arabics[i] ) do

    begin
      Decimal := Decimal - Arabics[i];
      scratch := scratch + Romans[i];

    end;

  Result := scratch;

end;



procedure TfrmConversor.edtRomanoKeyPress(Sender: TObject; var Key: Char);
begin
// Permitir somente letras
inherited;
if not (Key in['M','D','C','L','X','I','V','m','d','c','l','x','i','v',Chr(8)]) then
begin
 Application.MessageBox('Somente Algarismos Romanos por favor!','Aten��o',MB_ok +
MB_iconexclamation);
  Key:= #0;

end;
end;

function TfrmConversor.RomanoParaCardinal(const S: string): integer;
const
  RomanChars = ['C', 'D', 'I', 'L', 'M', 'V', 'X'];
  RomanValues: array['C'..'X'] of Word =
    (100, 500, 0, 0, 0, 0, 1, 0, 0, 50, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 10);
var
  Index, Next: Char;
  I: Integer;
  Negative: Boolean;
begin
  Result := 0;
  I := 0;
  Negative := (Length(S) > 0) and (S[1] = '-');
  if Negative then Inc(I);
  while (I < Length(S)) do begin
    Inc(I);
    Index := UpCase(S[I]);
    if Index in RomanChars then begin
      if Succ(I) <= Length(S) then Next := UpCase(S[I + 1])
      else Next := #0;
      if (Next in RomanChars) and (RomanValues[Index] < RomanValues[Next]) then
      begin
        Inc(Result, RomanValues[Next]);
        Dec(Result, RomanValues[Index]);
        Inc(I);
      end
      else Inc(Result, RomanValues[Index]);
    end
    else begin
      Result := 0;
      Exit;
    end;
  end;
  if Negative then Result := -Result;
end;

function IntToRoman(Value: Longint): string;
label
  A500, A400, A100, A90, A50, A40, A10, A9, A5, A4, A1;
begin
  Result := '';
{$IFNDEF WIN32}
  if (Value > MaxInt * 2) then Exit;
{$ENDIF}
  while Value >= 1000 do begin
    Dec(Value, 1000); Result := Result + 'M';
  end;
  if Value < 900 then goto A500
  else begin
    Dec(Value, 900); Result := Result + 'CM';
  end;
  goto A90;
  A400:
    if Value < 400 then goto A100
  else begin
    Dec(Value, 400); Result := Result + 'CD';
  end;
  goto A90;
  A500:
    if Value < 500 then goto A400
  else begin
    Dec(Value, 500); Result := Result + 'D';
  end;
  A100:
    while Value >= 100 do begin
    Dec(Value, 100); Result := Result + 'C';
  end;
  A90:
    if Value < 90 then goto A50
  else begin
    Dec(Value, 90); Result := Result + 'XC';
  end;
  goto A9;
  A40:
    if Value < 40 then goto A10
  else begin
    Dec(Value, 40); Result := Result + 'XL';
  end;
  goto A9;
  A50:
    if Value < 50 then goto A40
  else begin
    Dec(Value, 50); Result := Result + 'L';
  end;
  A10:
    while Value >= 10 do begin
    Dec(Value, 10); Result := Result + 'X';
  end;
  A9:
    if Value < 9 then goto A5
  else begin
    Result := Result + 'IX';
  end;
  Exit;
  A4:
    if Value < 4 then goto A1
  else begin
    Result := Result + 'IV';
  end;
  Exit;
  A5:
    if Value < 5 then goto A4
  else begin
    Dec(Value, 5); Result := Result + 'V';
  end;
  goto A1;
  A1:
    while Value >= 1 do begin
    Dec(Value); Result := Result + 'I';
  end;
end;

end.
