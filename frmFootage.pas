unit frmFootage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TFootageForm = class(TForm)
    imgFootage: TImage;
    bmbClose: TBitBtn;
    procedure bmbCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowFootage(FilePath : string);
  end;

var
  FootageForm: TFootageForm;

implementation

{$R *.dfm}

procedure TFootageForm.bmbCloseClick(Sender: TObject);
begin
  FootageForm.Destroy;
end;

procedure TFootageForm.ShowFootage(FilePath: string);
begin
  imgFootage.Picture.LoadFromFile(FilePath);
end;

end.
