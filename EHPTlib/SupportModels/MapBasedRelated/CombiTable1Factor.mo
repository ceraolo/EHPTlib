within EHPTlib.SupportModels.MapBasedRelated;

block CombiTable1Factor "CombiTable 1Ds, with input and output factors"
  parameter Integer nOut=1 "size of the output vector";
  parameter Real uFactor = 1 "Multiplies input before entering table";
  parameter Real yFactor = 1 "multiplies table outputs exiting the block";
  parameter Boolean tableOnFile = false "=true, if table is defined in a txt file";
  parameter Real[:, :] table = [0, 0; 1, 1; 2, 4] "Table matrix (as per CombiTable1ds)" annotation(
    Dialog(enable = not tableOnFile));
  parameter String tableName = "NoName" "Table name in txt file" annotation(
    Dialog(enable = tableOnFile));
  parameter String fileName = "NoName" "Txt file where matrix is stored" annotation(
    Dialog(enable = tableOnFile));
  Modelica.Blocks.Math.Gain toIn(k = uFactor_) annotation(
    Placement(transformation(origin = {-6, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain toOut[nOut](k = fill(yFactor_, nOut)) annotation(
    Placement(transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(transformation(origin = {-62, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nOut] annotation(
    Placement(transformation(origin = {122, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  final parameter Real uFactor_(fixed = false);
  final parameter Real yFactor_(fixed = false);
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(tableOnFile = tableOnFile, table = table, tableName = tableName, fileName = fileName) annotation(
    Placement(transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}})));
initial equation
  if tableOnFile then
    uFactor_ = uFactor;
    yFactor_ = yFactor;
  else
    uFactor_ = 1;
    yFactor_ = 1;
  end if;
equation
  connect(toIn.u, u) annotation(
    Line(points = {{-18, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(toIn.y, combiTable1Ds.u) annotation(
    Line(points = {{6, 0}, {22, 0}}, color = {0, 0, 127}));
  connect(toOut.u, combiTable1Ds.y) annotation(
    Line(points = {{70, 0}, {46, 0}}, color = {0, 0, 127}, thickness = 0.5));
  connect(y, toOut.y) annotation(
    Line(points = {{122, 0}, {94, 0}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    Diagram(coordinateSystem(extent = {{-60, -60}, {120, 60}})),
    Icon(graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(textColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Text(origin = {6, 6}, extent = {{-38, 8}, {38, -8}}, textString = "Combi1Ds"), Rectangle(origin = {2, 3}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-50, 73}, {50, -73}}), Text(origin = {3, 2}, extent = {{-47, 12}, {47, -12}}, textString = "CT"), Line(origin = {79.7692, -1.88462}, points = {{-28, 0}, {28, 0}}), Polygon(origin = {79, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-17, 17}, {17, -1}, {-17, -17}, {-17, -7}, {-17, 17}}), Rectangle(origin = {-4, 6}, fillColor = {255, 255, 170}, fillPattern = FillPattern.Solid, extent = {{-44, 70}, {-30, -76}}), Line(origin = {-76.2308, 0.11538}, points = {{-28, 0}, {28, 0}}), Polygon(origin = {-75, 1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-17, 17}, {17, -1}, {-17, -17}, {-17, -7}, {-17, 17}})}),
    Documentation(info = "<html><head></head><body><div>Blocks CombiTable1Factor and CombiTable2Factor implement the way EHTPlib uses matrices to determine components' behaviour such as torque limitation, optimal speeds, ICE consumptions, etc.</div><div><i>CombiTable1Factor is based on a MSL CombiTable1Ds, &nbsp;CombiTable2Factor on CombiTable2Ds.</i></div><div><br></div><div>These matrices can be directly written on the input mask, or taken from a file.</div><div><br></div><div>When they are taken from a file, it is very convenent to use factors on matrix inputs and output. This allows for instance to compensate usage of rpm instead of rad/s for speeds, or to re-use matrices in machines different from those they were originally written for, scaling input axes and ouptut.</div><div>For instance one could have a fuel consumption map of an ICE; which is adequate for a full family of engines: using these factors, it can be scaled to different speed/torque ranges, and omothetically varied also vertically (e.g. consumptions can be reduced to 90% by multiplication with an output factor equal to 0.9).</div><div><br></div><div><div>When matrix is not from a file, factors are automatically set to 1, and the input matrix is used without changes. When, instead, it is taken from a file, the two inputs are mutiplied by u1Factor and u2Factor respectively, and output by yFactor.</div></div></body></html>"));
end CombiTable1Factor;
