within EHPTlib.SupportModels.MapBasedRelated;
block CombiTable2Factor "CombiTable 2Ds, with input and output factors"
  parameter Real u1Factor = 1 "Multiplies input u1 before entering table";
  parameter Real u2Factor = 1 "Multiplies input u2 before entering table";
  parameter Real yFactor = 1 "multiplies table output exiting the block";
  parameter Boolean tableOnFile=false "=true, if table is defined in a txt file";
  parameter Real[:, :] table= fill(0.0, 0, 2) "Table matrix (as per CombiTable1ds)"
    annotation (Dialog(enable=not tableOnFile));
  parameter String tableName="NoName" "Table name in txt file"
    annotation (Dialog(enable= tableOnFile));
  parameter String fileName="NoName" "Txt file where matrix is stored"
    annotation (Dialog(enable= tableOnFile));
  Modelica.Blocks.Tables.CombiTable2Ds combiTable2s(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
  fileName = fileName, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
  table = table, tableName = tableName, tableOnFile = tableOnFile) annotation(
    Placement(transformation(origin = {46, 0}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Blocks.Math.Gain toIn1(k = u1Factor_) annotation(
    Placement(transformation(origin = {4, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain toIn2(k = u2Factor_) annotation(
    Placement(transformation(origin = {2, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain toOut(k = yFactor_) annotation(
    Placement(transformation(origin = {92, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput u1 annotation(
    Placement(transformation(origin = {-60, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 58}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput u2 annotation(
    Placement(transformation(origin = {-58, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(transformation(origin = {122, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  final parameter Real u1Factor_(fixed=false);
  final parameter Real u2Factor_(fixed=false);
  final parameter Real yFactor_(fixed=false);
initial equation
  if tableOnFile then
    u1Factor_=u1Factor;
    u2Factor_=u2Factor;
    yFactor_ =yFactor;
  else
    u1Factor_=1;
    u2Factor_=1;
    yFactor_ =1;
end if;

equation
  connect(toOut.u, combiTable2s.y) annotation(
    Line(points={{80,0},{59.2,0}},    color = {0, 0, 127}));
  connect(y, toOut.y) annotation(
    Line(points={{122,0},{103,0}},      color = {0, 0, 127}));
  connect(combiTable2s.u1, toIn1.y) annotation(
    Line(points={{31.6,7.2},{19.6,7.2},{19.6,20},{15,20}},                color = {0, 0, 127}));
  connect(combiTable2s.u2, toIn2.y) annotation(
    Line(points={{31.6,-7.2},{19.6,-7.2},{19.6,-20},{13,-20}},                color = {0, 0, 127}));
  connect(toIn1.u, u1) annotation(
    Line(points = {{-8, 20}, {-28, 20}, {-28, 40}, {-60, 40}}, color = {0, 0, 127}));
  connect(toIn2.u, u2) annotation(
    Line(points = {{-10, -20}, {-28, -20}, {-28, -40}, {-58, -40}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-60, -60}, {120, 60}})),
    Icon(graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(textColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Text(origin = {6, 6}, extent = {{-38, 8}, {38, -8}}, textString = "Combi1Ds"), Line(origin = {-70, 43}, points = {{-38, 15}, {-8, 15}, {-8, -15}, {38, -15}}), Polygon(origin = {-67, 29}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-17, 17}, {17, -1}, {-17, -17}, {-17, -7}, {-17, 17}}), Line(origin = {-72, -17}, points = {{-38, -43}, {-8, -43}, {-8, -15}, {38, -15}}), Polygon(origin = {-69, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-17, 17}, {17, -1}, {-17, -17}, {-17, -7}, {-17, 17}}), Rectangle(origin = {4, 3}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-48, 73}, {48, -73}}), Text(origin={9,2},    extent = {{-47, 12}, {47, -12}}, textString = "CT"), Line(origin = {79.7692, -1.88462}, points = {{-28, 0}, {28, 0}}), Polygon(origin = {79, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-17, 17}, {17, -1}, {-17, -17}, {-17, -7}, {-17, 17}}),
        Rectangle(
          extent={{-30,76},{52,64}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,64},{-30,-70}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid)}),
  Documentation(info = "<html><head></head><body><div><div>Blocks CombiTable1Factor and CombiTable2Factor implement the way EHTPlib uses matrices to determine components' behaviour such as torque limitation, optimal speeds, ICE consumptions, etc.</div><div><i>CombiTable1Factor is based on a MSL CombiTable1Ds, &nbsp;CombiTable2Factor on CombiTable2Ds.</i></div><div><br></div></div><div>These matrices can be directly written on the input mask, or taken from a file.</div><div><br></div><div>When they are taken from a file, it is very convenent to use factors on matrix inputs and output. This allows for instance to compensate usage of rpm instead of rad/s for speeds, or to re-use matrices in machines different from those they were originally written for, scaling input axes and ouptut.</div><div>For instance one could have a fuel consumption map of an ICE; which is adequate for a full family of engines: using these factors, it can be scaled to different speed/torque ranges, and omothetically varied also vertically (e.g. consumptions can be reduced to 90% by multiplication with an output factor equal to 0.9).</div><div><br></div><div><div>When matrix is not from a file, factors are automatically set to 1, and the input matrix is used without changes. When, instead, it is taken from a file, the two inputs are mutiplied by u1Factor and u2Factor respectively, and output by yFactor.</div></div></body></html>"));
end CombiTable2Factor;
