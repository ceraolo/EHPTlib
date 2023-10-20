within EHPTlib.SupportModels.Miscellaneous;
model Batt1Conn "Battery model based on Batt0 but with electric dynamics order = 1"
  Modelica.Units.SI.Power powDeliv
    "battery power (positive when delivered)";
  Real SOC "State Of Charge";
  parameter Modelica.Units.SI.ElectricCharge QCellNom(min=0) = 10*3.6e3
    "Nominal admissible electric charge per cell"
    annotation (Dialog(tab="Cell data"));
  parameter Modelica.Units.SI.Voltage ECellMin(min=0) = 3.3
    "Minimum open source voltage per cell"
    annotation (Dialog(tab="Cell data"));
  parameter Modelica.Units.SI.Voltage ECellMax(min=0.0001) = 4.15
    "Maximum open source voltage per cell"
    annotation (Dialog(tab="Cell data"));
  parameter Real SOCMin(min = 0, max = 1) = 0 "Minimum state of charge" annotation (
    Dialog(group = "SOC parameters"));
  parameter Real SOCMax(min = 0, max = 1) = 1 "Maximum state of charge" annotation (
    Dialog(group = "SOC parameters"));
  parameter Real SOCInit(min = 0, max = 1) = 0.5 "Initial state of charge" annotation (
    Dialog(group = "SOC parameters"));
  parameter Modelica.Units.SI.Current ICellMax(min=0) = 10*QCellNom/3.6e3
    "Maximum admissible current" annotation (Dialog(tab="Cell data"));
  parameter Modelica.Units.SI.Resistance R0Cell(min=0) = 0.05*ECellMax/
    ICellMax "Series resistance \"R0\"" annotation (Dialog(tab=
          "Cell data", group="Electric circuit parameters"));
  parameter Modelica.Units.SI.Resistance R1Cell(min=0) = R0Cell
    "Series resistance \"R1\"" annotation (Dialog(tab="Cell data", group=
          "Electric circuit parameters"));
  parameter Modelica.Units.SI.Capacitance C1Cell(min=0) = 60/R1Cell
    "Capacitance in parallel with R1" annotation (Dialog(tab="Cell data",
        group="Electric circuit parameters"));
  parameter Real efficiency(min = 0, max = 0.9999) = 0.85 "Overall charging/discharging energy efficiency" annotation (
    Dialog(group = "Parameters related to losses"));
  parameter Modelica.Units.SI.Current iCellEfficiency(min=0) = 0.5*
    ICellMax "Cell charging/discharging current the efficiency refers to"
    annotation (Dialog(group="Parameters related to losses"));
  parameter Integer ns = 1 "Number of serial connected cells" annotation (
    Dialog(tab = "Battery Pack data", group = "Size of the package"));
  parameter Integer np = 1 "Number of parallel connected cells" annotation (
    Dialog(tab = "Battery Pack data", group = "Size of the package"));
  Modelica.Units.SI.Voltage uBat(start=eBattMin + SOCInit*(eBattMax -
        eBattMin), fixed=true);
  // determine fraction of drain current with respect to the total package current
  Modelica.Electrical.Analog.Basic.Capacitor cBattery(final C = CBattery) annotation (
    Placement(transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.Analog.Basic.Resistor R0(final R = R0Battery) annotation (
    Placement(transformation(origin = {20, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Sources.SignalCurrent Ip annotation (
    Placement(transformation(origin = {-6, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.Analog.Interfaces.Pin p annotation (
    Placement(transformation(extent = {{90, 50}, {110, 70}}), iconTransformation(extent = {{90, 52}, {110, 72}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n annotation (
    Placement(transformation(extent = {{90, -70}, {110, -50}}), iconTransformation(extent = {{91, -70}, {111, -50}})));
  Modelica.Electrical.Analog.Basic.Capacitor C1(C = C1Battery) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {-37, 50})));
  EHPTlib.SupportModels.ConnectorRelated.Conn conn annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,-2})));
  Modelica.Blocks.Sources.RealExpression SOCs(y = SOC) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-80, 30})));
  Modelica.Blocks.Sources.RealExpression outPow(y = (p.v - n.v) * n.i) annotation (
    Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = -90, origin = {-80, -26})));
  Modelica.Electrical.Analog.Basic.Resistor R1(final R = R1Battery) annotation (
    Placement(visible = true, transformation(origin = {-37, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
protected
  parameter Real k = ((1 - efficiency) * (eBattMax + eBattMin) - 2 * (1 + efficiency) * Rtot * iCellEfficiency) / ((1 + efficiency) * (eBattMax + eBattMin) - 2 * (1 - efficiency) * Rtot * iCellEfficiency);
  parameter Real efficiencyMax = (eBattMin + eBattMax - 2 * Rtot * iCellEfficiency) / (eBattMin + eBattMax + 2 * Rtot * iCellEfficiency);
  final parameter Modelica.Units.SI.Capacitance C=QCellNom/(ECellMax -
      ECellMin) "Cell capacitance";
  parameter Modelica.Units.SI.Current IBatteryMax=ICellMax*np
    "Maximum battery current";
  parameter Modelica.Units.SI.Voltage eBattMin=ECellMin*ns
    "Minimum battery voltage";
  parameter Modelica.Units.SI.Voltage eBattMax=ECellMax*ns
    "Maximum battery voltage";
  parameter Modelica.Units.SI.ElectricCharge QBatteryNominal=QCellNom*np
    "Battery admissible electric charge";
  parameter Modelica.Units.SI.Capacitance CBattery=C*np/ns
    "Battery capacitance";
  parameter Modelica.Units.SI.Resistance R0Battery=R0Cell*ns/np
    "Series inner resistance R0 of cell package";
  parameter Modelica.Units.SI.Resistance R1Battery=R1Cell*ns/np
    "Series inner resistance R1 of cell package";
  parameter Modelica.Units.SI.Resistance Rtot=R0Battery + R1Battery;
  parameter Modelica.Units.SI.Capacitance C1Battery=C1Cell*np/ns
    "Battery series inner capacitance C1";
  Modelica.Units.SI.Voltage ECell "Cell e.m.f.";
  Modelica.Units.SI.Current iCellStray "Cell stray current";
  Modelica.Units.SI.Voltage eBatt(start=eBattMin + SOCInit*(eBattMax -
        eBattMin), fixed=true) "Battery e.m.f.";
  Modelica.Units.SI.Current iBatteryStray "Cell parasitic current";
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation (
    Placement(transformation(extent = {{70, 50}, {90, 70}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = k) annotation (
    Placement(transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Abs abs1 annotation (
    Placement(transformation(extent = {{34, -10}, {14, 10}}, rotation = 0)));
equation
  connect(R1.p, R0.n) annotation (
    Line(points = {{-27, 72}, {-18, 72}, {-18, 60}, {10, 60}}, color = {0, 0, 255}));
  connect(R1.p, C1.p) annotation (
    Line(points = {{-27, 72}, {-18, 72}, {-18, 50}, {-27, 50}}, color = {0, 0, 255}));
  connect(R1.n, cBattery.p) annotation (
    Line(points = {{-47, 72}, {-60, 72}, {-60, 10}}, color = {0, 0, 255}));
  assert(SOCMin >= 0, "SOCMin must be greater than, or equal to 0");
  assert(SOCMax <= 1, "SOCMax must be smaller than, or equal to 1");
  assert(efficiency <= efficiencyMax, "Charging/discharging energy efficiency too big with respect to the actual serial resistance (Max allowed =" + String(efficiencyMax) + ")");
  assert(SOCMin < SOCMax, "SOCMax(=" + String(SOCMax) + ") must be greater than SOCMin(=" + String(SOCMin) + ")");
  assert(SOCInit >= SOCMin, "SOCInit(=" + String(SOCInit) + ") must be greater than, or equal to SOCMin(=" + String(SOCMin) + ")");
  assert(SOCInit <= SOCMax, "SOCInit(=" + String(SOCInit) + ") must be smaller than, or equal to SOCMax(=" + String(SOCMax) + ")");
  iBatteryStray = Ip.i;
  iCellStray = iBatteryStray / np;
  uBat = p.v - n.v;
  eBatt = cBattery.v;
  //This was just to use a clearer name for the user
  ECell = eBatt / ns;
  powDeliv = (p.v - n.v) * n.i;
  assert(abs(p.i / np) < ICellMax, "Battery cell current i=" + String(abs(p.i / np)) + "\n exceeds max admissable ICellMax (=" + String(ICellMax) + "A)");
  SOC = (eBatt - eBattMin) / (eBattMax - eBattMin);
  //*(SOCMax-SOCMin)+SOCMin);
  assert(SOC <= SOCMax, "State of charge overcomes maximum allowed  (max=" + String(SOCMax) + ")");
  assert(SOC >= SOCMin, "State of charge is below minimum allowed (min=" + String(SOCMin) + ")");
  connect(R0.p, currentSensor.p) annotation (
    Line(points = {{30, 60}, {70, 60}}, color = {0, 0, 255}));
  connect(Ip.p, R0.n) annotation (
    Line(points = {{-6, 10}, {-6, 60}, {10, 60}}, color = {0, 0, 255}));
  connect(currentSensor.i, gain.u) annotation (
    Line(points={{80,49},{80,0},{72,0}},                                color = {0, 0, 127}));
  connect(abs1.u, gain.y) annotation (
    Line(points = {{36, 0}, {39.5, 0}, {39.5, 1.33227e-015}, {49, 1.33227e-015}}, color = {0, 0, 127}));
  connect(abs1.y, Ip.i) annotation (
    Line(points={{13,0},{7,0},{7,0},{6,-1.28588e-15}},                       color = {0, 0, 127}));
  connect(currentSensor.n, p) annotation (
    Line(points = {{90, 60}, {90, 60}, {100, 60}}, color = {0, 0, 255}));
  connect(Ip.n, n) annotation (
    Line(points = {{-6, -10}, {-6, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(n, cBattery.n) annotation (
    Line(points = {{100, -60}, {-60, -60}, {-60, -10}}, color = {0, 0, 255}));
  connect(C1.n, cBattery.p) annotation (
    Line(points = {{-47, 50}, {-60, 50}, {-60, 10}}, color = {0, 0, 255}, smooth = Smooth.None));
  connect(conn.batSOC, SOCs.y) annotation (
    Line(points = {{-100, -2}, {-100, 8.5}, {-80, 8.5}, {-80, 19}}, color = {255, 204, 51}, thickness = 0.5, smooth = Smooth.None),
    Text(string = "%first", index = -1, extent = {{-6, 3}, {-6, 3}}));
  connect(outPow.y, conn.batPowDel) annotation (
    Line(points = {{-80, -15}, {-80, -2}, {-100, -2}}, color = {0, 0, 127}, smooth = Smooth.None),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  annotation (
    Documentation(info = "<html>
<p>Battery model with non-unity coulombic efficiency. </p>
<p>The main cell branch contains an e.m.f. that is linearly increasing with SOC, simulated through an equivalent capacitor, the resistance R0 and a parallel R-C couple. </p>
<p>The full battery is composed by np rows in parallel, each of them containing ns cells in series.</p>
<p>It interfaces with monitoring systems tohrough an expandable connector. Output signals:</p>
<p>- state-of-charge &QUOT;batSOC&QUOT;</p>
<p>- outputted power &QUOT;batPowDel&QUOT;.</p>
</html>",
    revisions = "<html><table border=\"1\" rules=\"groups\">
    <thead>
    <tr><td>Version</td>  <td>Date</td>  <td>Comment</td></tr>
    </thead>
    <tbody>
    <tr><td>1.0.0</td>  <td>2006-01-12</td>  <td> </td></tr>
    <tr><td>1.0.3</td>  <td>2006-08-31</td>  <td> Improved assert statements </td></tr>
    <tr><td>1.0.6</td>  <td>2007-05-14</td>  <td> The documentation changed slightly </td></tr>
    </tbody>
    </table>
    </html>"),
    Diagram(coordinateSystem(extent = {{-100, -80}, {100, 80}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics),
    Icon(coordinateSystem(extent = {{-100, -80}, {100, 80}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Rectangle(lineColor = {95, 95, 95}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 80}, {80, -82}}), Line(points = {{-92, 6}, {-52, 6}}, color = {0, 0, 255}), Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-82, -3}, {-65, -10}}), Line(points = {{-73, 63}, {98, 64}}, color = {0, 0, 255}), Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{38, 69}, {68, 57}}), Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-37.5, 68}, {-6.5, 56}}), Line(points = {{-19.5, 49}, {-19.5, 32}}, color = {0, 0, 255}), Line(points = {{-54.5, 63}, {-54.5, 41}, {-25.5, 41}}, color = {0, 0, 255}), Line(points = {{9.5, 62}, {9.5, 40}, {-19.5, 40}}, color = {0, 0, 255}), Line(points = {{-73, 63}, {-73, 5}}, color = {0, 0, 255}), Line(points = {{-73, -6}, {-73, -60}, {96, -60}}, color = {0, 0, 255}), Line(points = {{26, 63}, {26, -61}}, color = {0, 0, 255}), Line(points = {{-25.5, 49}, {-25.5, 32}}, color = {0, 0, 255}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{26, 22}, {14, 4}, {26, -14}, {38, 4}, {26, 22}}), Line(points = {{20, 4}, {32, 4}}, color = {0, 0, 255}), Polygon(lineColor = {0, 0, 255}, points = {{22, -20}, {30, -20}, {26, -32}, {22, -20}}), Text(origin = {-4, -22}, lineColor = {0, 0, 255}, extent = {{-100, 150}, {100, 110}}, textString = "%name")}));
end Batt1Conn;
