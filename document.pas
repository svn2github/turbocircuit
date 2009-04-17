unit document;

{$mode delphi}

interface

uses
  Classes, SysUtils, LCLIntf,
  constants, dbcomponents, tcfileformat, tclists;

type

  { TDocument }

  TDocument = class(TObject)
  private
    procedure UpdateDocumentInfo(AIsSaved: Boolean);
    function  ReadBOF(AStream: TStream): Boolean;
    procedure WriteBOF(AStream: TStream);
    procedure WriteSCHEMATICS_GUI_DATA(AStream: TStream);
    procedure WriteSCHEMATICS_DOC_DATA(AStream: TStream);
    procedure WriteCOMPONENT(AStream: TStream; AElement: PTCElement);
    procedure WriteWIRE(AStream: TStream; AElement: PTCElement);
    procedure WriteTEXT(AStream: TStream; AElement: PTCElement);
    procedure WriteEOF(AStream: TStream);
  public
    { Non-Persistent information of the user interface }
    Modified: Boolean;
    Saved: Boolean;
    { Persistent information of the user interface }
    CurrentTool: TCTool;
    NewItemOrientation: TCComponentOrientation;
    Title: string;
    { Selection fields }
    SelectedComponent: PTCComponent;
    SelectedWire: PTCWire;
    SelectedText: PTCText;
    SelectionInfo: DWord;
    { Document information }
    SheetWidth, SheetHeight: Integer;
    Components: TCComponentList;
    Wires: TCWireList;
    TextList: TCTextList;
    { Base methods }
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(AFileName: string);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToFile(AFileName: string);
    procedure SaveToStream(AStream: TStream);
    { General document methods }
    function  GetDocumentPos(X, Y: Integer): TPoint;
    { Components methods }
    procedure RotateOrientation(var AOrientation: TCComponentOrientation);
    function  GetComponentTopLeft(AComponent: PTCComponent): TPoint;
    { Selection methods }
    procedure ClearSelection;
    function  IsSomethingSelected: Boolean;
  end;

var
  vDocument: TDocument;

implementation

{ TDocument }

procedure TDocument.UpdateDocumentInfo(AIsSaved: Boolean);
begin
  if AIsSaved then
  begin
    { Non-Persistent information of the user interface }
    Modified := False;
    Saved := True;
  end
  else
  begin
    { Non-Persistent information of the user interface }
    Modified := False;
    Saved := False;
  end;
end;

function TDocument.ReadBOF(AStream: TStream): Boolean;
var
  vID: array[0..INT_TCFILE_IDENTIFIER_SIZE-1] of Char;
begin
  Result := False;

  AStream.ReadBuffer(vID, INT_TCFILE_IDENTIFIER_SIZE);

  if not CompareMem(@vID, @STR_TCFILE_IDENTIFIER[1], INT_TCFILE_IDENTIFIER_SIZE) then Exit;

  if AStream.ReadByte <> TCRECORD_BOF then Exit;
  
  AStream.ReadByte;
  AStream.ReadWord;
  
  Result := True;
end;

procedure TDocument.WriteBOF(AStream: TStream);
begin
  AStream.WriteBuffer(STR_TCFILE_IDENTIFIER[1], INT_TCFILE_IDENTIFIER_SIZE);
  AStream.WriteByte(TCRECORD_BOF);
  AStream.WriteByte(TCRECORD_BOF_VER);
  AStream.WriteWord($0);
end;

procedure TDocument.WriteSCHEMATICS_GUI_DATA(AStream: TStream);
begin

end;

procedure TDocument.WriteSCHEMATICS_DOC_DATA(AStream: TStream);
begin

end;

procedure TDocument.WriteCOMPONENT(AStream: TStream; AElement: PTCElement);
var
  AComponent: PTCComponent absolute AElement;
begin
  AStream.WriteByte(TCRECORD_COMPONENT);
  AStream.WriteByte(TCRECORD_COMPONENT_VER);
  AStream.WriteWord(TCRECORD_COMPONENT_SIZE);
  AStream.WriteBuffer(AComponent^, SizeOf(TCComponent));
end;

procedure TDocument.WriteWIRE(AStream: TStream; AElement: PTCElement);
var
  AWire: PTCWire absolute AElement;
begin
  AStream.WriteByte(TCRECORD_WIRE);
  AStream.WriteByte(TCRECORD_WIRE_VER);
  AStream.WriteWord(TCRECORD_WIRE_SIZE);
  AStream.WriteBuffer(AWire^, SizeOf(TCWire));
end;

procedure TDocument.WriteTEXT(AStream: TStream; AElement: PTCElement);
var
  AText: PTCText absolute AElement;
begin
  AStream.WriteByte(TCRECORD_TEXT);
  AStream.WriteByte(TCRECORD_TEXT_VER);
  AStream.WriteWord(TCRECORD_TEXT_SIZE);
  AStream.WriteBuffer(AText^, SizeOf(TCText));
end;

procedure TDocument.WriteEOF(AStream: TStream);
begin

end;

constructor TDocument.Create;
begin
  inherited Create;

  { Creates the lists of items }
  Components := TCComponentList.Create;
  Wires := TCWireList.Create;
  TextList := TCTextList.Create;

  { Initialization of various fields }
  CurrentTool := toolArrow;
  NewItemOrientation := coEast;

  SheetWidth := INT_SHEET_DEFAULT_WIDTH;
  SheetHeight := INT_SHEET_DEFAULT_HEIGHT;

  { Update fields after IO }
  UpdateDocumentInfo(False);
end;

destructor TDocument.Destroy;
begin
  { Cleans the memory of the lists of items }
  Components.Free;
  Wires.Free;
  TextList.Free;

  inherited Destroy;
end;

procedure TDocument.LoadFromFile(AFileName: string);
var
  AFileStream: TFileStream;
begin
  AFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    LoadFromStream(AFileStream);
  finally
    AFileStream.Free;
  end;

  { Update fields }
  Title := ExtractFileName(AFileName);
end;

procedure TDocument.LoadFromStream(AStream: TStream);
var
  ARecID, ARecVer: Byte;
  ARecSize: Word;
  AComponent: PTCComponent;
  AWire: PTCWire;
  AText: PTCText;
begin
  { First try to verify if the file is valid }
  if not ReadBOF(AStream) then raise Exception.Create('Invalid Turbo Circuit BOF');

  { Update fields after IO }
  UpdateDocumentInfo(True);

  { clears old data }
  Components.Clear;
  Wires.Clear;

  { Reads all records }
  while AStream.Position < AStream.Size do
  begin
    ARecID := AStream.ReadByte;
    ARecVer := AStream.ReadByte;
    ARecSize := AStream.ReadWord;
    
    case ARecID of
    
    TCRECORD_BOF: Exit; // Shouldn't be here

    TCRECORD_GUI_DATA:
    begin
      { Persistent information of the user interface }
//  CurrentTool := TCTool(AStream.ReadDWord);
//  NewComponentOrientation := TCComponentOrientation(AStream.ReadDWord);
    { Selection fields }
//    SelectedComponent: PTCComponent;
//    SelectedWire: PTCWire;
//    SelectedWirePart: TCWirePart;
    { Document information }
//  SheetWidth := AStream.ReadDWord;
//  SheetHeight := AStream.ReadDWord;
    end;

    TCRECORD_DOC_DATA:
    begin
    end;

    TCRECORD_COMPONENT:
    begin
      New(AComponent);
      AStream.Read(AComponent^, SizeOf(TCComponent));
    
      Components.Insert(AComponent);
    end;

    TCRECORD_WIRE:
    begin
      New(AWire);
      AStream.Read(AWire^, SizeOf(TCWire));

      Wires.Insert(AWire);
    end;

    TCRECORD_TEXT:
    begin
      New(AText);
      AStream.Read(AText^, SizeOf(TCText));

      TextList.Insert(AText);
    end;

    TCRECORD_EOF: Exit;
    
    end;
  end;
end;

procedure TDocument.SaveToFile(AFileName: string);
var
  AFileStream: TFileStream;
begin
  AFileStream := TFileStream.Create(AFileName, fmOpenWrite or fmCreate);
  try
    SaveToStream(AFileStream);
  finally
    AFileStream.Free;
  end;

  { Update fields }
  Title := ExtractFileName(AFileName);
end;

procedure TDocument.SaveToStream(AStream: TStream);
begin
  { Update fields after IO }
  UpdateDocumentInfo(True);

  { First the identifier of any TurboCircuit schematics file }
  WriteBOF(AStream);

  { Persistent information of the user interface }
//  AStream.WriteDWord(LongWord(CurrentTool));
//  AStream.WriteDWord(LongWord(NewComponentOrientation));
  { Selection fields }
//    SelectedComponent: PTCComponent;
//    SelectedWire: PTCWire;
//    SelectedWirePart: TCWirePart;
  { Document information }
//  AStream.WriteDWord(SheetWidth);
//  AStream.WriteDWord(SheetHeight);

  { Stores the components }
  Components.ForEachDoWrite(AStream, WriteCOMPONENT);

  { Stores the wires }
  Wires.ForEachDoWrite(AStream, WriteWIRE);

  { Stores the text elements }
  TextList.ForEachDoWrite(AStream, WriteTEXT);
end;

function TDocument.GetDocumentPos(X, Y: Integer): TPoint;
begin
  Result.X := Round(X / INT_SHEET_GRID_SPACING);
  Result.Y := Round(Y / INT_SHEET_GRID_SPACING);
end;

procedure TDocument.RotateOrientation(var AOrientation: TCComponentOrientation);
begin
  case AOrientation of
    coEast:  AOrientation := coNorth;
    coNorth: AOrientation := coWest;
    coWest:  AOrientation := coSouth;
    coSouth: AOrientation := coEast;
  end;
end;

function TDocument.GetComponentTopLeft(AComponent: PTCComponent): TPoint;
var
  ComponentWidth, ComponentHeight: Integer;
begin
  ComponentWidth := vComponentsDatabase.GetWidth(AComponent^.TypeID);
  ComponentHeight := vComponentsDatabase.GetHeight(AComponent^.TypeID);

  case AComponent^.Orientation of

    coEast:
    begin
      Result.X := AComponent^.Pos.X;
      Result.Y := AComponent^.Pos.Y;
    end;

    coNorth:
    begin
      Result.X := AComponent^.Pos.X;
      Result.Y := AComponent^.Pos.Y - ComponentWidth;
    end;

    coWest:
    begin
      Result.X := AComponent^.Pos.X - ComponentWidth;
      Result.Y := AComponent^.Pos.Y - ComponentHeight;
    end;

    coSouth:
    begin
      Result.X := AComponent^.Pos.X - ComponentHeight;
      Result.Y := AComponent^.Pos.Y;
    end;
  end;
end;

procedure TDocument.ClearSelection;
begin
  SelectedComponent := nil;
  SelectedWire := nil;
  SelectedText := nil;
  SelectionInfo := ELEMENT_DOES_NOT_MATCH;
end;

function TDocument.IsSomethingSelected: Boolean;
begin
  Result := (SelectedComponent <> nil) or (SelectedWire <> nil);
end;

initialization

  vDocument := TDocument.Create;

finalization

  vDocument.Free;

end.

