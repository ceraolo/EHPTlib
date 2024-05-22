within EHPTlib.MapBased;
model Genset "GenSet GMS+GEN+SEngine"
  import Modelica.Constants.inf;
  import Modelica.Constants.pi;
  parameter Real gsRatio = 2 "IdealGear speed reduction factor";
  parameter String mapsFileName = "maps.txt" "File containing data maps (maxIceTau, gensetDriveEffTable, specificCons, optiSpeed)";
  parameter Modelica.Units.SI.AngularVelocity maxGenW=1e6
    "Max generator angular speed";
  parameter Modelica.Units.SI.Torque maxTau=200
    "Max mechanical torque between internal ICE and generator";
  parameter Modelica.Units.SI.Power maxPow=20e3
    "Max mechanical power of the internal generator";
  parameter Modelica.Units.SI.AngularVelocity wIceStart=167;
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation (
    Placement(transformation(extent = {{-8, -8}, {8, 8}}, rotation = 180, origin = {-24, -20})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor IcePow annotation (
    Placement(transformation(extent={{24,0},{42,18}})));
  Modelica.Blocks.Interfaces.RealInput powRef(unit = "W") "Reference genset power" annotation (
    Placement(transformation(extent = {{15, -15}, {-15, 15}}, rotation = 90, origin = {61, 115})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(transformation(extent = {{90, 50}, {110, 70}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = inf, uMin = 0) annotation (
    Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = 90, origin = {-80, 54})));
  ECUs.GMS myGMS(mapsFileName = mapsFileName) annotation (
    Placement(transformation(extent = {{-70, 10}, {-50, 30}})));
  EHPTlib.MapBased.OneFlange gen(
    wMax=maxGenW,
    mapsFileName=mapsFileName,
    mapsOnFile=true,
    powMax=maxPow,
    tauMax=maxTau,
    effTableName="gensetDriveEffTable") annotation (Placement(visible=true,
        transformation(extent={{68,18},{48,-2}}, rotation=0)));
  IceT01 mBiceT(tablesOnFile = true, mapsFileName = mapsFileName, wIceStart = wIceStart) annotation (
    Placement(transformation(extent={{-34,-2},{-14,20}})));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation (
    Placement(transformation(extent = {{-14, 30}, {6, 50}})));
  Modelica.Blocks.Math.Gain gain1(k = 1) annotation (
    Placement(visible = true, transformation(origin = {-60, -8}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
  Modelica.Blocks.Continuous.Integrator toGrams(k = 1 / 3600) annotation (
    Placement(transformation(extent = {{18, -42}, {38, -22}})));
  Modelica.Mechanics.Rotational.Components.IdealGear idealGear(ratio = gsRatio) annotation (
    Placement(visible = true, transformation(extent={{0,0},{18,18}},      rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(transformation(extent={{90,-30},{110,-10}}), iconTransformation(
          extent={{92,-70},{112,-50}})));
equation
  connect(gain.y, gen.tauRef) annotation (
    Line(points={{7,40},{76,40},{76,8},{68.2,8},{68.2,9.11111}},                          color = {0, 0, 127}));
  connect(gen.pin_n, pin_p) annotation (
    Line(points={{68,13.5556},{80,13.5556},{80,60},{100,60}},          color = {0, 0, 255}));
  connect(IcePow.flange_b, gen.flange_a) annotation (
    Line(points={{42,9},{46,9},{46,9.11111},{48,9.11111}}));
  connect(gain1.u, speedSensor.w) annotation (
    Line(points = {{-60, -15.2}, {-60, -20}, {-32.8, -20}}, color = {0, 0, 127}));
  connect(myGMS.Wmecc, gain1.y) annotation (
    Line(points = {{-59.9, 8.5}, {-60, 8.5}, {-60, -1.4}}, color = {0, 0, 127}));
  connect(limiter.u, powRef) annotation (
    Line(points = {{-80, 66}, {-80, 80}, {61, 80}, {61, 115}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(limiter.y, myGMS.pRef) annotation (
    Line(points = {{-80, 43}, {-80, 20}, {-72, 20}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(mBiceT.nTauRef, myGMS.throttle) annotation (
    Line(points={{-30,-2},{-30,-6},{-49,-6},{-49,14}},          color = {0, 0, 127}));
  connect(speedSensor.flange, mBiceT.flange_a) annotation (
    Line(points={{-16,-20},{-6,-20},{-6,9},{-14,9}},            color = {0, 0, 0}));
  connect(gain.u, myGMS.tRef) annotation (
    Line(points = {{-16, 40}, {-40, 40}, {-40, 26}, {-49, 26}}, color = {0, 0, 127}));
  connect(toGrams.u, mBiceT.fuelCons) annotation (
    Line(points={{16,-32},{8,-32},{8,-10},{-18,-10},{-18,-0.9}},                   color = {0, 0, 127}));
  connect(idealGear.flange_a, mBiceT.flange_a) annotation (
    Line(points={{0,9},{-14,9}},                            color = {0, 0, 0}));
  connect(idealGear.flange_b, IcePow.flange_a) annotation (
    Line(points={{18,9},{24,9}},                          color = {0, 0, 0}));
  connect(gen.pin_p, pin_n) annotation (Line(points={{68,4.66667},{68,-20},{100,
          -20}}, color={0,0,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 100}})),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255},
            fillPattern = FillPattern.Solid), Text(extent = {{-98, 94}, {78, 68}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255},
            fillPattern = FillPattern.Solid, textString = "%name"), Rectangle(fillColor = {192, 192, 192},
            fillPattern = FillPattern.HorizontalCylinder, extent = {{-20, 0}, {26, -14}}), Rectangle(fillColor = {192, 192, 192},
            fillPattern = FillPattern.HorizontalCylinder, extent = {{-44, 30}, {-14, -44}}), Line(points = {{-72, 30}, {-72, 6}}), Polygon(points = {{-72, -2}, {-78, 8}, {-66, 8}, {-72, -2}}), Rectangle(extent = {{-96, 38}, {-50, -48}}), Rectangle(fillColor = {95, 95, 95},
            fillPattern = FillPattern.Solid, extent = {{-96, -6}, {-50, -24}}), Rectangle(fillColor = {135, 135, 135},
            fillPattern = FillPattern.Solid, extent = {{-78, -24}, {-68, -44}}), Polygon(points = {{-72, 34}, {-78, 24}, {-66, 24}, {-72, 34}}), Rectangle(fillColor = {192, 192, 192},
            fillPattern = FillPattern.HorizontalCylinder, extent = {{6, 30}, {62, -44}}), Line(points = {{94, 60}, {74, 60}, {74, 18}, {62, 18}}, color = {0, 0, 255}), Line(points = {{100, -60}, {74, -60}, {74, -28}, {62, -28}}, color = {0, 0, 255})}),
    Documentation(info="<html>
<p>Generator set containing Internal Combustion Engine (ICE), electric generator (with DC output), and the related control.</p>
<p>The control logic tends to deliver at the DC port the input power, using the optimal generator speed.</p>
<p><i>Note on parameters.</i></p>
<p>The internal ICE data are supplied through maps to be provided through a txt file. The values explicitly set through the <i>Parameters </i>dialog box refer to the internal generator (except wIceStart). Any change on these should be made considering joint changes in the ICE maps.</p>
</html>"));
end Genset;
