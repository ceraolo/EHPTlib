within EHPTlib.MapBased;
model GensetOO "GenSet GMS+GEN+SEngine with On/Off"
  import Modelica.Constants.inf;
  import Modelica.Constants.pi;
  parameter Real gsRatio = 2 "IdealGear speed reduction factor";
  parameter String mapsFileName = "maps.txt" "Name of the file containing data maps (names: maxIceTau, specificCons, optiSpeed)";
  parameter Modelica.Units.SI.AngularVelocity maxGenW=1e6;
  parameter Modelica.Units.SI.Torque maxTau=200 "Max mechanical torque";
  parameter Modelica.Units.SI.Power maxPow=20e3 "Max mechanical power";
  parameter Modelica.Units.SI.AngularVelocity wIceStart=300;
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation (
    Placement(visible = true, transformation(origin = {-26, -40}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
  Modelica.Mechanics.Rotational.Components.IdealGear idealGear(ratio = gsRatio) annotation (
    Placement(visible = true, transformation(extent = {{0, -18}, {18, 0}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput ON "when true engine is ON" annotation (
    Placement(visible = true, transformation(origin = {-55, 69}, extent = {{15, -15}, {-15, 15}}, rotation = 90), iconTransformation(origin = {-60, 116}, extent = {{15, -15}, {-15, 15}}, rotation = 90)));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor IcePow annotation (
    Placement(visible = true, transformation(extent = {{22, -18}, {40, 0}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput powRef(unit = "W") "Reference genset power" annotation (
    Placement(visible = true, transformation(origin = {59, 71}, extent = {{15, -15}, {-15, 15}}, rotation = 90), iconTransformation(extent = {{15, -15}, {-15, 15}}, rotation = 90, origin = {60, 116})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(extent = {{88, 30}, {108, 50}}, rotation = 0), iconTransformation(extent = {{90, 50}, {110, 70}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(extent = {{88, -50}, {108, -30}}, rotation = 0), iconTransformation(extent = {{92, -70}, {112, -50}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = inf, uMin = 0) annotation (
    Placement(visible = true, transformation(origin = {-82, 36}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  ECUs.GMSoo gms(mapsFileName = mapsFileName, throttlePerWerr = 0.1, tablesOnFile = true) annotation (
    Placement(visible = true, transformation(extent = {{-72, -10}, {-52, 10}}, rotation = 0)));
  OneFlange gen(wMax = maxGenW, mapsFileName = mapsFileName, mapsOnFile = true, powMax = maxPow, tauMax = maxTau, effTableName = "gensetDriveEffTable") annotation (
    Placement(visible = true, transformation(extent = {{68, 2}, {48, -18}}, rotation = 0)));
  IceT01 mbIce(wIceStart = wIceStart, mapsFileName = mapsFileName, iceJ = 10, tablesOnFile = true) annotation (
    Placement(visible = true, transformation(extent = {{-36, -22}, {-16, -2}}, rotation = 0)));
  Modelica.Blocks.Math.Gain revGain(k = -0.9 * gsRatio) annotation (
    Placement(visible = true, transformation(extent = {{-10, 10}, {10, 30}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator toGrams(k = 1 / 3600) annotation (
    Placement(transformation(extent = {{18, -48}, {38, -28}})));
equation
  connect(revGain.y, gen.tauRef) annotation (
    Line(points={{11,20},{68.2,20},{68.2,-6.88889}},        color = {0, 0, 127}));
  connect(gen.pin_p, pin_n) annotation (
    Line(points={{68,-11.3333},{76,-11.3333},{76,-40},{98,-40}},          color = {0, 0, 255}));
  connect(gen.pin_n, pin_p) annotation (
    Line(points = {{68, -2.44444}, {78, -2.44444}, {78, 40}, {98, 40}}, color = {0, 0, 255}));
  connect(IcePow.flange_b, gen.flange_a) annotation (
    Line(points = {{40, -9}, {44, -9}, {44, -8.88889}, {45.875, -8.88889}, {45.875, -6.88889}, {48, -6.88889}}));
  connect(IcePow.flange_a, idealGear.flange_b) annotation (
    Line(points = {{22, -9}, {18, -9}}));
  connect(revGain.u, gms.tRef) annotation (
    Line(points = {{-12, 20}, {-38, 20}, {-38, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(mbIce.flange_a, idealGear.flange_a) annotation (
    Line(points={{-16,-12},{-12,-12},{-6,-12},{-6,-9},{0,-9}}));
  connect(mbIce.nTauRef, gms.throttle) annotation (
    Line(points = {{-32, -22}, {-32, -26}, {-51, -26}, {-51, -6}}, color = {0, 0, 127}));
  connect(ON, gms.on) annotation (
    Line(points = {{-55, 69}, {-55, 18}, {-73.8, 18}, {-73.8, 6}}, color = {255, 0, 255}));
  connect(limiter.y, gms.pRef) annotation (
    Line(points = {{-82, 25}, {-82, 0}, {-74, 0}}, color = {0, 0, 127}));
  connect(speedSensor.w, gms.Wmecc) annotation (
    Line(points = {{-34.8, -40}, {-61.9, -40}, {-61.9, -11.5}}, color = {0, 0, 127}));
  connect(limiter.u, powRef) annotation (
    Line(points = {{-82, 48}, {-82, 52}, {59, 52}, {59, 71}}, color = {0, 0, 127}));
  connect(speedSensor.flange, idealGear.flange_a) annotation (
    Line(points = {{-18, -40}, {-6, -40}, {-6, -9}, {0, -9}}));
  connect(toGrams.u, mbIce.fuelCons) annotation (
    Line(points = {{16, -38}, {2, -38}, {2, -30}, {-20, -30}, {-20, -21}}, color = {0, 0, 127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 60}})),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255},
            fillPattern = FillPattern.Solid), Text(extent = {{-98, 94}, {78, 68}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255},
            fillPattern = FillPattern.Solid, textString = "%name"), Rectangle(fillColor = {192, 192, 192},
            fillPattern = FillPattern.HorizontalCylinder, extent = {{-20, 0}, {26, -14}}), Rectangle(fillColor = {192, 192, 192},
            fillPattern = FillPattern.HorizontalCylinder, extent = {{-44, 30}, {-14, -44}}), Line(points = {{-72, 30}, {-72, 6}}), Polygon(points = {{-72, -2}, {-78, 8}, {-66, 8}, {-72, -2}}), Rectangle(extent = {{-96, 38}, {-50, -48}}), Rectangle(fillColor = {95, 95, 95},
            fillPattern = FillPattern.Solid, extent = {{-96, -6}, {-50, -24}}), Rectangle(fillColor = {135, 135, 135},
            fillPattern = FillPattern.Solid, extent = {{-78, -24}, {-68, -44}}), Polygon(points = {{-72, 34}, {-78, 24}, {-66, 24}, {-72, 34}}), Rectangle(fillColor = {192, 192, 192},
            fillPattern = FillPattern.HorizontalCylinder, extent = {{6, 30}, {62, -44}}), Line(points = {{94, 60}, {74, 60}, {74, 18}, {62, 18}}, color = {0, 0, 255}), Line(points = {{100, -60}, {74, -60}, {74, -28}, {62, -28}}, color = {0, 0, 255})}),
    Documentation(info = "<html>
<p>Generator set containing Internal Combustion Engine, Electric generator (with DC output), and the related control.</p>
<p>The control logic tends to deliver at the DC port the input power, using the optimal generator speed.</p>
<p>In addition, it switches ON or OFF depending on the input boolean control signal.</p>
</html>"),
    __OpenModelica_commandLineOptions = "");
end GensetOO;
