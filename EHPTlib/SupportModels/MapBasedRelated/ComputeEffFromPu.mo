within EHPTlib.SupportModels.MapBasedRelated;
block ComputeEffFromPu "adds drive losses function of W/Wmax and T/Tmax"
  parameter Real A = 0.006 "fixed losses";
  parameter Real bT = 0.05 "torque losses coefficient";
  parameter Real bW = 0.02 "speed losses coefficient";
  parameter Real bP = 0.05 "power losses coefficient";
  Real lossesPu "losses pu of Wmax*Tmax";
  Modelica.Blocks.Interfaces.RealInput Wu "angular speed, pu of Wmax" annotation (
    Placement(transformation(extent = {{-138, -80}, {-98, -40}})));
  Modelica.Blocks.Interfaces.RealOutput y "computed efficiency" annotation (
    Placement(transformation(extent = {{96, -10}, {116, 10}})));
  Modelica.Blocks.Interfaces.RealInput Tu "Torque pu of Tmax" annotation (
    Placement(transformation(extent = {{-138, 40}, {-98, 80}})));
equation
  lossesPu = A + bT * Tu ^ 2 + bW * Wu ^ 2 + bP * (Tu * Wu) ^ 2;
  y = Tu * Wu /(Tu * Wu + lossesPu);

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}),                                                                                                                                                                           Text(lineColor = {0, 0, 127}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent={{-100,
              147},{100,107}},                                                                                                                                                                                                        textString = "%name"), Text(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent={{-98,14},
              {102,-14}},
          textString="eta=f(T,W)",
          textColor={0,0,0})}));
end ComputeEffFromPu;
