within EHPTlib.ElectricDrives.SMArelated;
model MTPAalExperimental
  "MTPA logic for an anisotropic PMSM machine with current limitation"
  // Non-Ascii Symbol to cause UTF-8 saving by Dymola: €
  parameter Modelica.Units.SI.Time integTime = 2;
  parameter Real gain(unit = "N.m/A") = 5000/(1.5*Ipm*pp) "Current loop gain";
  parameter Modelica.Units.SI.Current Ipm = 1.5 "Permanent magnet current";
  parameter Integer pp = 1 "Pole pairs";
  parameter Modelica.Units.SI.Resistance Rs = 0.02 "Stator resistance";
  parameter Modelica.Units.SI.Inductance Ld = 0.4 "Basic direct-axis inductance";
  parameter Modelica.Units.SI.Inductance Lq = 1.1 "Basic quadrature-axis inductance";
  parameter Modelica.Units.SI.Voltage Umax = 100 "Max rms voltage per phase to the motor";
  parameter Modelica.Units.SI.Current Ilim = 100 "nominal current (rms per phase)";
  Modelica.Blocks.Interfaces.RealInput torqueReq annotation (
    Placement(transformation(extent = {{-140, 40}, {-100, 80}}), iconTransformation(extent = {{-140, 40}, {-100, 80}})));
  Modelica.Blocks.Interfaces.RealInput wMech annotation (
    Placement(transformation(extent = {{-140, -80}, {-100, -40}}), iconTransformation(extent = {{-140, -80}, {-100, -40}})));
  Modelica.Blocks.Interfaces.RealOutput Id annotation (
    Placement(transformation(extent = {{100, 50}, {120, 70}}), iconTransformation(extent = {{100, 50}, {120, 70}})));
  Modelica.Blocks.Interfaces.RealOutput Iq annotation (
    Placement(transformation(extent = {{100, -70}, {120, -50}}), iconTransformation(extent = {{100, -70}, {120, -50}})));
  Modelica.Blocks.Interfaces.RealInput uDC "DC voltage" annotation (
    Placement(transformation(extent = {{-140, -20}, {-100, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
  MTPAa mTPAa(
    Ipm=Ipm,
    pp=pp,
    Rs=Rs,
    Ld=Ld,
    Lq=Lq,
    Umax=Umax) annotation (Placement(transformation(extent={{6,-36},{26,-16}})));
  Modelica.Blocks.Math.Feedback feedback annotation (
    Placement(visible = true, transformation(extent = {{38, 14}, {58, 34}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Ilim_(k = IlimPk) annotation (
    Placement(visible = true, transformation(origin = {48, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 1e99, uMin = 0) annotation (
    Placement(visible = true, transformation(origin = {6, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation (
    Placement(visible = true, transformation(origin = {-34, 8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 0.01, k = 1) annotation (
    Placement(visible = true, transformation(extent = {{-74, 50}, {-54, 70}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold limiting(threshold = IlimPk/1e6) annotation (
    Placement(visible = true, transformation(extent = {{-14, 18}, {6, 38}}, rotation = 0)));
  Modelica.Blocks.Continuous.PI pi(T = integTime, k = gain) annotation (
    Placement(visible = true, transformation(origin = {48, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
protected
  parameter Modelica.Units.SI.Current IlimPk = sqrt(2)*Ilim "current limit (A peak)";
equation
  connect(firstOrder1.y, add1.u2) annotation (
    Line(points = {{-53, 60}, {-40, 60}, {-40, 20}}, color = {0, 0, 127}));
  connect(firstOrder1.u, torqueReq) annotation (
    Line(points = {{-76, 60}, {-120, 60}}, color = {0, 0, 127}));
  connect(limiting.u, add1.u1) annotation (
    Line(points = {{-16, 28}, {-28, 28}, {-28, 20}}, color = {0, 0, 127}));
  connect(add1.y, mTPAa.torqueReq) annotation (
    Line(points = {{-34, -3}, {-34, -20}, {4, -20}}, color = {0, 0, 127}));
  connect(limiter1.y, add1.u1) annotation (
    Line(points = {{-5, 60}, {-28, 60}, {-28, 20}}, color = {0, 0, 127}));
  connect(feedback.u1, mTPAa.Ipark) annotation (
    Line(points = {{40, 24}, {16, 24}, {16, -15}}, color = {0, 0, 127}));
  connect(Ilim_.y, feedback.u2) annotation (
    Line(points = {{48, 11}, {48, 16}}, color = {0, 0, 127}));
  connect(mTPAa.uDC, uDC) annotation (
    Line(points = {{4, -26}, {-68, -26}, {-68, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(mTPAa.wMech, wMech) annotation (
    Line(points = {{4, -32}, {4, -32}, {-34, -32}, {-34, -60}, {-120, -60}}, color = {0, 0, 127}));
  connect(mTPAa.Id, Id) annotation (
    Line(points = {{27, -20}, {27, -20}, {86, -20}, {86, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(mTPAa.Iq, Iq) annotation (
    Line(points = {{27, -32}, {27, -32}, {86, -32}, {86, -60}, {110, -60}}, color = {0, 0, 127}));
  connect(limiter1.u, pi.y) annotation (
    Line(points={{18,60},{37,60}},      color = {0, 0, 127}, pattern = LinePattern.Solid));
  connect(pi.u, feedback.y) annotation (
    Line(points={{60,60},{72,60},{72,24},{57,24}},          color = {0, 0, 127}, pattern = LinePattern.Solid));
  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Text(textColor = {0, 0, 127}, extent = {{-100, 142}, {100, 106}}, textString = "%name"), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, pattern = LinePattern.Solid, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(textColor = {0, 0, 127}, extent={{-102,62},
              {98,12}},                                                                                                                                                                                                        textString = "MTPAal"),
        Text(
          extent={{-100,-42},{100,-66}},
          textColor={238,46,47},
          textString="experimental")}),
    Diagram(coordinateSystem(extent = {{-100, -80}, {100, 80}}, preserveAspectRatio = false)),
    Documentation(info="<html>
<p><span style=\"font-size: 12pt;\">This is an experimental version used only for SmaALlSpeeds. 
Operation of PI controller not well calibrated for all applications, since it lacks antiwindup.</span></p>
</html>"));
end MTPAalExperimental;
