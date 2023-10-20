within EHPTlib.SupportModels.Miscellaneous;
model Batt1 "Battery model based on one R-C block in its electric circuit"
  parameter Modelica.Units.SI.ElectricCharge QCellNom(min=0) = 10*3600.0
    "Nominal electric charge" annotation (Dialog(tab="Cell data"));
  parameter Modelica.Units.SI.Voltage ECellMin(min=0) = 3.3
    "Minimum open source voltage" annotation (Dialog(tab="Cell data"));
  parameter Modelica.Units.SI.Voltage ECellMax(min=0.0001) = 4.15
    "Maximum open source voltage" annotation (Dialog(tab="Cell data"));
  parameter Real SOCMin(min = 0, max = 1) = 0 "Minimum state of charge" annotation (
    Dialog(group = "SOC parameters"));
  parameter Real SOCMax(min = 0, max = 1) = 1 "Maximum state of charge" annotation (
    Dialog(group = "SOC parameters"));
  parameter Real SOCInit(min = 0, max = 1) = 0.5 "Initial state of charge" annotation (
    Dialog(group = "SOC parameters"));
  parameter Modelica.Units.SI.Current ICellMax(min=0) = 10*QCellNom/
    3600.0 "Maximum admissible current"
    annotation (Dialog(tab="Cell data"));
  parameter Modelica.Units.SI.Resistance R0Cell(min=0) = 0.05*ECellMax/
    ICellMax "Serial resistance \"R0\"" annotation (Dialog(tab=
          "Cell data", group="Electric circuit parameters"));
  parameter Modelica.Units.SI.Resistance R1Cell(min=0) = R0Cell
    "Serial resistance \"R1\"" annotation (Dialog(tab="Cell data", group=
          "Electric circuit parameters"));
  parameter Modelica.Units.SI.Capacitance C1Cell(min=0) = 60/R1Cell
    "Capacitance in parallel with R1" annotation (Dialog(tab="Cell data",
        group="Electric circuit parameters"));
  parameter Real efficiency(min = 0, max = 0.99) = 0.85 "Charging/discharging energy efficiency" annotation (
    Dialog(group = "Parameters related to losses"));
  parameter Modelica.Units.SI.Current iCellEfficiency(min=0) = 0.5*
    ICellMax "Charging/discharging current the efficiency refers to"
    annotation (Dialog(group="Parameters related to losses"));
  parameter Integer ns = 1 "Number of serial connected cells per string" annotation (
    Dialog(tab = "Battery pack data", group = "Size of the package"));
  parameter Integer np = 1 "Number of parallel connected strings" annotation (
    Dialog(tab = "Battery pack data", group = "Size of the package"));
  Modelica.Units.SI.Voltage uBat(start=EBatteryMin + SOCInit*(EBatteryMax
         - EBatteryMin), fixed=true);
  Modelica.Units.SI.Power powerLoss;
  Modelica.Electrical.Analog.Basic.Capacitor cBattery(final C = CBattery) annotation (
    Placement(transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.Analog.Basic.Resistor R0(final R = R0Battery) annotation (
    Placement(transformation(origin = {20, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Sources.SignalCurrent Ip annotation (
    Placement(transformation(origin = {-6, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.Analog.Interfaces.Pin p annotation (
    Placement(transformation(extent = {{90, 50}, {110, 70}}), iconTransformation(extent = {{90, 50}, {110, 70}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n annotation (
    Placement(transformation(extent = {{90, -70}, {110, -50}}), iconTransformation(extent = {{91, -70}, {111, -50}})));
  Modelica.Electrical.Analog.Basic.Resistor R1(final R = R1Battery) annotation (
    Placement(transformation(origin = {-37, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Capacitor C1(C = C1Battery) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {-37, 50})));
  Modelica.Blocks.Interfaces.RealOutput SOC annotation (
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Capacitor cDummy(C = C1Battery / 10000) annotation (
    Placement(visible = true, transformation(origin = {88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  // The following row is substituted by the next one, since this fomula erroneously mixed cell data with battery data:
  // it would give wrong results whenever np>1
  // parameter Real efficiencyMax = (EBatteryMin + EBatteryMax - 2 * Rtot * iCellEfficiency) / (EBatteryMin + EBatteryMax + 2 * Rtot * iCellEfficiency);
protected
  parameter Real efficiencyMax = (ECellMin + ECellMax - 2 * RtotCell * iCellEfficiency) / (ECellMin + ECellMax + 2 * RtotCell * iCellEfficiency);
  parameter Modelica.Units.SI.Capacitance C=QCellNom/(ECellMax - ECellMin)
    "Cell capacitance";
  // the following k is the fraction of parasitic current Ip of the total package current
  parameter Real k = ((1 - efficiency) * (EBatteryMax + EBatteryMin) - 2 * (1 + efficiency) * Rtot * iCellEfficiency) / ((1 + efficiency) * (EBatteryMax + EBatteryMin) - 2 * (1 - efficiency) * Rtot * iCellEfficiency);
  parameter Modelica.Units.SI.Current IBatteryMax=ICellMax*np
    "Maximum battery current";
  parameter Modelica.Units.SI.Voltage EBatteryMin=ECellMin*ns
    "Minimum battery voltage";
  parameter Modelica.Units.SI.Voltage EBatteryMax=ECellMax*ns
    "Maximum battery voltage";
  parameter Modelica.Units.SI.ElectricCharge QBatteryNominal=QCellNom*np
    "Battery admissible electric charge";
  parameter Modelica.Units.SI.Capacitance CBattery=C*np/ns
    "Battery capacitance";
  parameter Modelica.Units.SI.Resistance R0Battery=R0Cell*ns/np
    "Serial inner resistance R0 of cell package";
  parameter Modelica.Units.SI.Resistance R1Battery=R1Cell*ns/np
    "Serial inner resistance R1 of cell package";
  parameter Modelica.Units.SI.Resistance Rtot=R0Battery + R1Battery;
  parameter Modelica.Units.SI.Resistance RtotCell=R0Cell + R1Cell;
  parameter Modelica.Units.SI.Capacitance C1Battery=C1Cell*np/ns
    "Battery series inner capacitance C1";
protected
  Modelica.Units.SI.Voltage ECell "Cell e.m.f.";
  Modelica.Units.SI.Current iCellStray "Cell stray current";
  Modelica.Units.SI.Voltage EBattery(start=EBatteryMin + SOCInit*(
        EBatteryMax - EBatteryMin), fixed=true) "Battery e.m.f.";
  Modelica.Units.SI.Current iBatteryStray "Cell parasitic current";
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation (
    Placement(transformation(extent = {{60, 50}, {80, 70}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = k) annotation (
    Placement(transformation(origin = {52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Abs abs1 annotation (
    Placement(transformation(extent = {{34, -10}, {14, 10}}, rotation = 0)));
equation
  connect(cDummy.n, n) annotation (
    Line(points = {{88, -10}, {88, -10}, {88, -60}, {100, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(cDummy.p, currentSensor.n) annotation (
    Line(points = {{88, 10}, {88, 10}, {88, 60}, {80, 60}, {80, 60}}, color = {0, 0, 255}));
  assert(SOCMin >= 0, "SOCMin must be greater than, or equal to 0");
  assert(SOCMax <= 1, "SOCMax must be smaller than, or equal to 1");
  assert(efficiency <= efficiencyMax, "Charging/discharging energy efficiency too big with respect to the actual serial resistance (Max allowed =" + String(efficiencyMax) + ")");
  assert(SOCMin < SOCMax, "SOCMax(=" + String(SOCMax) + ") must be greater than SOCMin(=" + String(SOCMin) + ")");
  assert(SOCInit >= SOCMin, "SOCInit(=" + String(SOCInit) + ") must be greater than, or equal to SOCMin(=" + String(SOCMin) + ")");
  assert(SOCInit <= SOCMax, "SOCInit(=" + String(SOCInit) + ") must be smaller than, or equal to SOCMax(=" + String(SOCMax) + ")");
  iBatteryStray = Ip.i;
  iCellStray = iBatteryStray / np;
  EBattery = cBattery.v;
  //This was just to use a clearer name for the user
  uBat = p.v - n.v;
  powerLoss = R0.LossPower + R1.LossPower + Ip.v * Ip.i;
  ECell = EBattery / ns;
  assert(abs(p.i / np) < ICellMax, "Battery cell current i=" + String(abs(p.i / np)) + "\n exceeds max admissable ICellMax (=" + String(ICellMax) + "A)");
  SOC = (EBattery - EBatteryMin) / (EBatteryMax - EBatteryMin);
  //*(SOCMax-SOCMin)+SOCMin);
  assert(SOC <= SOCMax, "State of charge overcomes maximum allowed (max=" + String(SOCMax) + ")");
  assert(SOC >= SOCMin, "State of charge is below minimum allowed (min=" + String(SOCMin) + ")");
  connect(R0.p, currentSensor.p) annotation (
    Line(points = {{30, 60}, {60, 60}}, color = {0, 0, 255}));
  connect(Ip.p, R0.n) annotation (
    Line(points = {{-6, 10}, {-6, 60}, {10, 60}}, color = {0, 0, 255}));
  connect(currentSensor.i, gain.u) annotation (
    Line(points={{70,49},{70,0},{64,0}},                                color = {0, 0, 127}));
  connect(abs1.u, gain.y) annotation (
    Line(points = {{36, 0}, {39.5, 0}, {39.5, 1.34711e-015}, {41, 1.34711e-015}}, color = {0, 0, 127}));
  connect(abs1.y, Ip.i) annotation (
    Line(points={{13,0},{7,0},{7,0},{6,-1.28588e-15}},                       color = {0, 0, 127}));
  connect(currentSensor.n, p) annotation (
    Line(points = {{80, 60}, {80, 60}, {100, 60}}, color = {0, 0, 255}));
  connect(Ip.n, n) annotation (
    Line(points = {{-6, -10}, {-6, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(n, cBattery.n) annotation (
    Line(points = {{100, -60}, {-60, -60}, {-60, -10}}, color = {0, 0, 255}));
  connect(R1.n, cBattery.p) annotation (
    Line(points = {{-47, 74}, {-60, 74}, {-60, 10}}, color = {0, 0, 255}, smooth = Smooth.None));
  connect(C1.n, cBattery.p) annotation (
    Line(points = {{-47, 50}, {-60, 50}, {-60, 10}}, color = {0, 0, 255}, smooth = Smooth.None));
  connect(R1.p, C1.p) annotation (
    Line(points = {{-27, 74}, {-18, 74}, {-18, 50}, {-27, 50}}, color = {0, 0, 255}, smooth = Smooth.None));
  connect(R1.p, R0.n) annotation (
    Line(points = {{-27, 74}, {-18, 74}, {-18, 60}, {10, 60}}, color = {0, 0, 255}, smooth = Smooth.None));
  annotation (
    Documentation(info="<html>
<p>Battery model with non-unity coulombic efficiency. </p>
<p>The main cell branch contains an e.m.f. that is linearly increasing with SOC, simulated through an equivalent capacitor, the resistance R0 and a parallel R-C couple. </p>
<p>The full battery is composed by np rows in parallel, each of them containing ns cells in series (or, equivalently, ns parallels of np cells in series)</p>
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
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics),
    Icon(coordinateSystem(initialScale = 0.1), graphics={  Rectangle(lineColor = {95, 95, 95}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {78, -100}}), Line(origin = {2, -2}, points = {{-92, 7}, {-56, 7}}, color = {0, 0, 255}), Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-82, -3}, {-65, -10}}), Line(points = {{-73, 63}, {98, 64}}, color = {0, 0, 255}), Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{38, 69}, {68, 57}}), Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-37.5, 68}, {-6.5, 56}}), Line(points = {{-19.5, 49}, {-19.5, 32}}, color = {0, 0, 255}), Line(points = {{-54.5, 63}, {-54.5, 41}, {-25.5, 41}}, color = {0, 0, 255}), Line(points = {{9.5, 62}, {9.5, 40}, {-19.5, 40}}, color = {0, 0, 255}), Line(points = {{-73, 63}, {-73, 5}}, color = {0, 0, 255}), Line(points = {{-73, -6}, {-73, -60}, {96, -60}}, color = {0, 0, 255}), Line(points = {{26, 63}, {26, -61}}, color = {0, 0, 255}), Line(points = {{-25.5, 49}, {-25.5, 32}}, color = {0, 0, 255}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{26, 22}, {14, 4}, {26, -14}, {38, 4}, {26, 22}}), Line(points = {{20, 4}, {32, 4}}, color = {0, 0, 255}), Polygon(lineColor = {0, 0, 255}, points = {{22, -20}, {30, -20}, {26, -32}, {22, -20}}), Text(lineColor = {0, 0, 255}, extent = {{-100, 150}, {100, 110}}, textString = "%name"), Text(origin={-54,-1},    lineColor = {238, 46, 47}, extent={{-4,3},{
              12,-13}},                                                                                                                                                                                                        textString = "E", fontName = "Times New Roman"), Text(origin={-26,83},    lineColor = {238, 46, 47}, extent={{-6,3},{
              18,-13}},                                                                                                                                                                                                        textString = "R1", fontName = "Times New Roman"), Text(origin={-26,29},    lineColor = {238, 46, 47}, extent={{-6,3},{
              18,-13}},                                                                                                                                                                                                        textString = "C1", fontName = "Times New Roman"), Text(origin={41.5,
              10.625},                                                                                                                                                                                                        lineColor = {238, 46, 47}, extent={{-5.5,
              3.375},{16.5,-14.625}},                                                                                                                                                                                                        textString = "Ip", fontName = "Times New Roman"), Text(origin={47.5,85},  lineColor = {238, 46, 47}, extent={{-5.5,3},
              {16.5,-13}},                                                                                                                                                                                                        textString = "R0", fontName = "Times New Roman")}));
end Batt1;
