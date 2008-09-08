unit constants;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses Classes, Graphics;

{*******************************************************************
*  Main data structures
*******************************************************************}
type
  { Base data structures for components }
  
  PTCElement = ^TCElement;

  TCElement = object
    Pos: TPoint;
    Next, Previous: PTCElement;
  end;

  { Data structures for components }

  TCComponentOrientation = (coEast = 0, coNorth = 1, coWest = 2, coSouth = 3);

  PTCComponent = ^TCComponent;

  TCComponent = object(TCElement)
    Name: string;
    TypeID: Integer;
    Orientation: TCComponentOrientation;
  end;
  
  { Data structures for wires }

  PTCWire = ^TCWire;

  TCWire = object(TCElement)
    PtTo: TPoint;
  end;
  
  { Data structures for text }

  PTCText = ^TCText;

  TCText = object(TCElement)
    BottomRight: TPoint;
    Text: shortstring;
  end;

  { Data structures for tools }

  TCTool = (toolArrow = 0, toolComponent, toolWire, toolText);
  
{*******************************************************************
*  Element verification constants
*******************************************************************}
const
  ELEMENT_DOES_NOT_MATCH = 0;
  ELEMENT_MATCHES        = 1;
  ELEMENT_START_POINT    = 2;
  ELEMENT_END_POINT      = 3;

{*******************************************************************
*  General use data structures
*******************************************************************}
type
  { Used by tcutils.SeparateString }
  T10Strings = array[0..9] of shortstring;
  
  { Used by CalculateCoordinate }
  TFloatPoint = record
    X, Y: Double;
  end;

{*******************************************************************
*  Drawing code commands
*******************************************************************}
const
  STR_DRAWINGCODE_LINE      = 'LINE';
  STR_DRAWINGCODE_TEXT      = 'TEXT';
  STR_DRAWINGCODE_ARC       = 'ARC';
  STR_DRAWINGCODE_TRIANGLE  = 'TRIANGLE';

{*******************************************************************
*  Database field names
*******************************************************************}
const
  STR_DB_COMPONENTS_FILE        = 'components.dat';
  STR_DB_COMPONENTS_TABLE       = 'Components';
  STR_DB_COMPONENTS_ID          = 'ID';
  STR_DB_COMPONENTS_NAMEEN      = 'NAMEEN';
  STR_DB_COMPONENTS_NAMEPT      = 'NAMEPT';
  STR_DB_COMPONENTS_DRAWINGCODE = 'DRAWINGCODE';
  STR_DB_COMPONENTS_HEIGHT      = 'HEIGHT';
  STR_DB_COMPONENTS_WIDTH       = 'WIDTH';
  STR_DB_COMPONENTS_PINS        = 'PINS';

{*******************************************************************
*  StatusBar panel identifiers
*******************************************************************}
const
  ID_STATUS_MOUSEPOS        = 0;

{*******************************************************************
*  General User Interface constants
*******************************************************************}
const
  INT_SHEET_GRID_SPACING     = 10;
  INT_SHEET_GRID_HALFSPACING = INT_SHEET_GRID_SPACING div 2;
  INT_SHEET_MAX_WIDTH        = 1000;
  INT_SHEET_MAX_HEIGHT       = 1000;
  INT_SHEET_DEFAULT_WIDTH    = 500;
  INT_SHEET_DEFAULT_HEIGHT   = 500;

{*******************************************************************
*  Strings not to be translated
*******************************************************************}
const

  szAppTitle  = 'Turbo Circuit';

  lpSeparator = '-';
  lpComma     = ',';
  lpSpace     = ' ';

  lpEnglish   = 'English';
  lpPortugues = 'Português';

{$ifdef GoboLinux}
  DefaultDirectory = '/Programs/TurboCircuit/0.1/';
{$else}
  DefaultDirectory = '/usr/share/magnifier/';
{$endif}
  BundleResourcesDirectory = '/Contents/Resources/';

implementation

end.

