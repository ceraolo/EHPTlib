within EHPTlib.ElectricDrives.ASMArelated;
block ControlLogic "Follows upper fig. 12.15 from FEPE Book"
  import Modelica.Constants.pi;
  parameter Modelica.Units.SI.Resistance Rr(start=0.04)
    "Rotor resistance";
  parameter Modelica.Units.SI.Resistance Rs(start=0.03)
    "Stator resistance";
  parameter Modelica.Units.SI.Voltage uBase(start=400)
    "Base phase-to-phase RMS voltage";
  parameter Modelica.Units.SI.AngularVelocity weBase=314.16
    "Base electric frequency";
  parameter Modelica.Units.SI.Inductance Lstray(start=0.2036/weBase)
    "Combined stray inductance";
  parameter Modelica.Units.SI.AngularVelocity wmMax=314.16
    "Maximum mechanical Speed";
  parameter Integer pp(min = 1, start = 2) "number of pole pairs (Integer)";
  //La seguente keyword final consente fra l'altro di far scomparire questi parametri dalla maschera.
  final parameter Real Kw(fixed = true) = uBase / sqrt(3) / (weBase / pp) "Ratio U/Wmecc";
  Modelica.Blocks.Interfaces.RealInput Wm annotation (
    Placement(transformation(extent = {{-160, -80}, {-120, -40}}), iconTransformation(extent = {{-13, -13}, {13, 13}}, rotation = 90, origin = {1, -113})));
  Modelica.Blocks.Interfaces.RealOutput Ustar annotation (
    Placement(transformation(extent = {{120, -50}, {140, -30}}), iconTransformation(extent = {{100, -70}, {120, -50}})));
  Modelica.Blocks.Interfaces.RealInput Tstar annotation (
    Placement(transformation(extent = {{-160, 40}, {-120, 80}}), iconTransformation(extent = {{-13, -13}, {13, 13}}, rotation = 0, origin = {-119, -1})));
  Modelica.Blocks.Math.Add add annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-38, 56})));
  Modelica.Blocks.Nonlinear.Limiter limWm(uMax=wmMax, uMin=uBase/sqrt(3)/
        100/Kw,
    homotopyType=Modelica.Blocks.Types.LimiterHomotopy.Linear)
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Modelica.Blocks.Interfaces.RealOutput Westar annotation (
    Placement(transformation(extent = {{120, 50}, {140, 70}}), iconTransformation(extent = {{100, 50}, {120, 70}})));
  ASMArelated.TorqueToDW tauToDW(Rr = Rr, pp = pp, Kw = Kw, Lstray = Lstray, wmBase = weBase / pp) annotation (
    Placement(transformation(extent = {{-100, 50}, {-80, 70}})));
  Modelica.Blocks.Math.Gain gain(k = pp) annotation (
    Placement(transformation(extent = {{62, 50}, {82, 70}})));
  Modelica.Blocks.Math.Add add1(k1 = Rs, k2 = Kw) annotation (
    Placement(transformation(extent = {{40, 10}, {60, -10}})));
  Modelica.Blocks.Nonlinear.Limiter limU(uMax = uBase / sqrt(3), uMin = 0) annotation (
    Placement(transformation(extent = {{76, -10}, {96, 10}})));
  Modelica.Blocks.Logical.GreaterThreshold toWeakening(threshold = limU.uMax) annotation (
    Placement(visible = true, transformation(origin = {66, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.GreaterThreshold toMaxSpeed(threshold = limWm.uMax) annotation (
    Placement(visible = true, transformation(origin = {-10, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression toIstar(y = sqrt(abs(Tstar * tauToDW.y / (3 * Rs)))) annotation (
    Placement(transformation(extent = {{-30, -18}, {8, 0}})));
equation
  connect(toMaxSpeed.u, limWm.u) annotation (
    Line(points = {{-10, 40}, {-10, 40}, {-10, 60}, {-2, 60}, {-2, 60}, {-2, 60}}, color = {0, 0, 127}));
  connect(limWm.u, add.y) annotation (
    Line(points = {{-2, 60}, {-12, 60}, {-12, 72}, {-38, 72}, {-38, 67}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(Tstar, tauToDW.u) annotation (
    Line(points = {{-140, 60}, {-122, 60}, {-122, 66}, {-102, 66}}, color = {0, 0, 127}));
  connect(tauToDW.y, add.u1) annotation (
    Line(points = {{-79, 60}, {-79, 60}, {-74, 60}, {-74, 44}, {-44, 44}}, color = {0, 0, 127}));
  connect(add.u2, Wm) annotation (
    Line(points = {{-32, 44}, {-32, 44}, {-32, 14}, {-110, 14}, {-110, -18}, {-110, -18}, {-110, -60}, {-140, -60}}, color = {0, 0, 127}));
  connect(Westar, gain.y) annotation (
    Line(points = {{130, 60}, {106, 60}, {83, 60}}, color = {0, 0, 127}));
  connect(gain.u, limWm.y) annotation (
    Line(points = {{60, 60}, {50, 60}, {20, 60}, {21, 60}}, color = {0, 0, 127}));
  connect(add1.y, limU.u) annotation (
    Line(points = {{61, 0}, {74, 0}}, color = {0, 0, 127}));
  connect(limU.y, Ustar) annotation (
    Line(points = {{97, 0}, {102, 0}, {102, -40}, {130, -40}}, color = {0, 0, 127}));
  connect(tauToDW.Wm, Wm) annotation (
    Line(points = {{-102, 54}, {-110, 54}, {-110, -60}, {-140, -60}}, color = {0, 0, 127}));
  connect(add1.u2, limWm.y) annotation (
    Line(points = {{38, 6}, {34, 6}, {34, 60}, {21, 60}}, color = {0, 0, 127}));
  connect(toWeakening.u, limU.u) annotation (
    Line(points = {{66, -24}, {66, 0}, {74, 0}}, color = {0, 0, 127}));
  connect(toIstar.y, add1.u1) annotation (
    Line(points = {{9.9, -9}, {22, -9}, {22, -6}, {38, -6}}, color = {0, 0, 127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-120, -80}, {120, 80}}, initialScale = 0.1), graphics={  Text(origin = {0, -4}, lineColor = {0, 0, 127}, extent = {{-48, -12}, {22, -22}}, textString = "This is the first equality \nin 12.14 of FEPE Book"), Text(origin = {0, -16}, lineColor = {0, 0, 127}, extent = {{-48, -12}, {22, -22}}, textString = "The sqrt argument might become negative
because of roundoff errors. This justifies abs()")}),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-64, -54}, {-64, 72}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-72, 62}, {-64, 74}, {-58, 62}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-78, -46}, {66, -46}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-7, -6}, {1, 6}, {7, -6}}, color = {0, 0, 127}, smooth = Smooth.None, origin = {59, -45}, rotation = 270), Line(points = {{-70, -32}, {0, 36}, {52, 36}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-71, -27}, {-55, -27}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-71, 35}, {-55, 35}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-2, -18}, {-2, -50}, {-2, -40}}, color = {0, 0, 127}, smooth = Smooth.None), Text(extent = {{-102, 144}, {96, 106}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name"), Text(extent = {{58, 72}, {94, 44}}, lineColor = {0, 0, 127}, textString = "W"), Text(extent = {{64, -48}, {96, -74}}, lineColor = {0, 0, 127}, textString = "U")}),
    Documentation(info = "<html>
<p>This class produces a three-phase voltage system to variable-frequency control of an asynchronous motor.</p>
<p>The output voltages constitute a three-phase system of quasi-sinusoidal shapes, created according to the following equations:</p>
<p>Wel=Wmecc*PolePairs+DeltaWel</p>
<p>U=U0+(Un-U0)*(Wel)/Wnom</p>
<p>where:</p>
<ul>
<li>U0, Un U, are initial, nominal and actual voltage amplitudes</li>
<li>Wmecc, Wel are machine (mechanical) and supply (electrical) angular speeds</li>
<li>PolePairs are the number of machine pole pairs</li>
<li>DeltaWel is the difference between synchnonous angular speed and mechichal speed (divided by pole pairs). It is a non-linear function of the input  torque.</li>
</ul>
</html>"),
    experiment(StopTime = 500, Interval = 0.1));
end ControlLogic;
