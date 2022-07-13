program ProjetoConversor;

uses
  Vcl.Forms,
  uConversor in 'uConversor.pas' {frmConversor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmConversor, frmConversor);
  Application.Run;
end.
