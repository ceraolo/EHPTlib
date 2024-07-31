within EHPTlib.SupportModels.MapBasedRelated;
block LimTorqueCT "Defines torque limits based on values from a CombiTable"
  Modelica.Blocks.Interfaces.RealInput w annotation (
    Placement(transformation(extent = {{-140, -20}, {-100, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
  Modelica.Blocks.Interfaces.RealOutput yH annotation (
    Placement(transformation(extent = {{100, 50}, {120, 70}})));
  parameter Boolean limitsOnFile = false "= true, if max torque is taken from a txt file";
  parameter Modelica.Units.SI.Power powMax=50000
    "Maximum mechanical power"
    annotation (Dialog(enable=not limitsOnFile));
  parameter Modelica.Units.SI.Torque tauMax=400 "Maximum torque"
    annotation (Dialog(enable=not limitsOnFile));
  parameter Modelica.Units.SI.AngularVelocity wMax= 1500 "Maximum speed" annotation (Dialog(enable=not limitsOnFile));
  parameter String limitsFileName = "noName" "File where matrix is stored" annotation (
    Dialog(enable = limitsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required table is")));
  parameter String maxTorqueTableName = "noName" "Name of the on-file maximum torque as a function of speed" annotation (
    Dialog(enable = limitsOnFile));
  parameter String minTorqueTableName = "noName" "Name of the on-file minimum torque as a function of speed" annotation (
    Dialog(enable = limitsOnFile));
  Integer state "=0 below base speed; =1 before wMax; =2 in w limit, =3 above wMax";
  //0 or 1 if tauMax or powMax is delivered; =2 or 3 if w>wMax; -1 if limitsOnFile
  Real yHidealised "valore del limite di coppia in caso di curve idealizzate (T cost. sotto la velocità base, P cost. sopra)";
protected
  parameter Real alpha = 0.10 "fraction of wMax over which the torque is to be brought to zero";
public
  Modelica.Blocks.Interfaces.RealOutput yL annotation (
    Placement(transformation(extent = {{100, -70}, {120, -50}})));
  Modelica.Blocks.Tables.CombiTable1Ds toMaxTq(tableOnFile = limitsOnFile, table = [0, 0; 1, 1; 2, 4], tableName = maxTorqueTableName, fileName = limitsFileName, smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2, extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints) annotation (
    Placement(transformation(extent = {{-10, 30}, {10, 50}})));
  Modelica.Blocks.Tables.CombiTable1Ds toMinTq(tableOnFile = limitsOnFile, table = [0, 0; 1, 1; 2, 4], tableName = minTorqueTableName, fileName = limitsFileName, smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2, extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints) annotation (
    Placement(transformation(extent = {{-10, -50}, {10, -30}})));
  Modelica.Blocks.Math.UnitConversions.To_rpm to_rpm annotation (
    Placement(transformation(extent = {{-78, -10}, {-58, 10}})));
algorithm
  if w < powMax / tauMax then
    state := 0;
    yHidealised := tauMax;
  else
    state := 1;
    yHidealised := powMax / w;
  end if;
  //over wMax the torque max is to be rapidly brought to zero
  if w > wMax then
    if w < (1 + alpha) * wMax then
      state := 2;
      yHidealised := powMax / wMax * (1 - (w - wMax) / (alpha * wMax));
    else
      state := 3;
      yHidealised := 0;
    end if;
  end if;
  if limitsOnFile then
    state := -1;
  end if;
equation
  if limitsOnFile then
    yH = toMaxTq.y[1];
    yL = toMinTq.y[1];
  else
    yH = yHidealised;
    yL = -yHidealised;
  end if;
  connect(w, to_rpm.u) annotation (
    Line(points = {{-120, 0}, {-80, 0}}, color = {0, 0, 127}));
  connect(toMaxTq.u, toMinTq.u) annotation (
    Line(points = {{-12, 40}, {-30, 40}, {-30, -40}, {-12, -40}}, color = {0, 0, 127}));
  connect(to_rpm.y, toMinTq.u) annotation (
    Line(points = {{-57, 0}, {-30, 0}, {-30, -40}, {-12, -40}}, color = {0, 0, 127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={Text(origin = {2, 53}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-98, 73}, {96, 41}}, textString = "%name
          "),
        Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 90}, {100, -88}}), Line(points = {{-72, 80}, {-72, -80}}, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 2), Text(lineColor = {0, 0, 255}, extent = {{-98, 54}, {-84, 48}}, textString = "T"), Line(points = {{92, -2}, {-74, -2}}, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 2), Text(lineColor = {0, 0, 255}, extent = {{72, -22}, {86, -28}}, textString = "W"), Line(points = {{-72, 54}, {-12, 54}, {2, 46}, {16, 26}, {30, 18}, {43.9863, 14.0039}, {86, 10}}, thickness = 0.5), Line(points = {{-72, -2}, {-62, -2}, {-52, -48}, {-8, -48}, {4, -42}, {16, -20}, {34, -12}, {86, -8}}, thickness = 0.5)}),
    Documentation(info = "<html>
<p>Gives the maximum output torque as a function of the input speed. </p>
<p>There are two possibilities dependig on the value of limitsOnFile.</p>
<p><b>If limitsOnFile=false</b></p>
<p>When w&lt;wMax the output is Tmax if Tmax*w&lt;Pnom, othersise it is Pnom/w </p>
<p>But if w is over wMax Tmax is rapidly falling to zero (reaches zero when speed overcomes wMax by 10&percnt;). </p>
<p><b>If limitsOnFile=true</b></p>
<p>maximum and minimum torques arre taken from a txt file. Default interpaltion is with ontinuous derivative. No maxmimum speed is considered.</p>
<p><br>Torques and powers are in SI units </p>
</html>"));
end LimTorqueCT;
