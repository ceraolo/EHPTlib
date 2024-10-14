within EHPTlib.SupportModels.MapBasedRelated;
block LimTorque "Defines torque limits based on values from a CombiTable"
  Modelica.Blocks.Interfaces.RealInput w annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-140, -20}, {-100, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
  Modelica.Blocks.Interfaces.RealOutput yH annotation(
    Placement(transformation(origin = {-34, -20}, extent = {{100, 50}, {120, 70}}), iconTransformation(extent = {{100, 50}, {120, 70}})));
  parameter Boolean limitsOnFile = false "= true, if max torque is taken from a txt file";/*annotation(choices(checkBox=true))*/
  parameter Modelica.Units.SI.Power powMax = 50000 "Maximum mechanical power" annotation(
    Dialog(enable = not limitsOnFile));
  parameter Modelica.Units.SI.Torque tauMax = 400 "Maximum torque" annotation(
    Dialog(enable = not limitsOnFile));
  parameter Modelica.Units.SI.AngularVelocity wMax = 1500 "Maximum speed" annotation(
    Dialog(enable = not limitsOnFile));
  parameter String limitsFileName = "noName" "File where matrix is stored" annotation(
    Dialog(enable = limitsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required table is")));
  parameter String limitsTableName = "noName" "Name of the on-file maximum torque as a function of speed" annotation(
    Dialog(enable = limitsOnFile));
  Integer state "=0 below base speed; =1 before wMax; =2 in w limit, =3 above wMax";
  //0 or 1 if tauMax or powMax is delivered; =2 or 3 if w>wMax; -1 if limitsOnFile
  Real yHidealised "valore del limite di coppia in caso di curve idealizzate (T cost. sotto la velocità base, P cost. sopra)";
  final parameter Real baseSpeed = powMax/wMax;
  Modelica.Blocks.Interfaces.RealOutput yL annotation(
    Placement(transformation(origin = {-32, 20}, extent = {{100, -70}, {120, -50}}), iconTransformation(extent = {{100, -70}, {120, -50}})));
  Modelica.Blocks.Tables.CombiTable1Ds toMinMaxTq(tableOnFile = limitsOnFile,
    table=[0,0,0; 1,-1,1; 2,-4,4],                                                                        tableName = limitsTableName, fileName = limitsFileName, smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2, extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints, columns = {2, 3}) annotation(
    Placement(transformation(origin = {-28, 40}, extent = {{40, -50}, {60, -30}})));
protected
  parameter Real alpha = 0.05 "fraction of wMax over which the torque is to be brought to zero";
  constant Real one = 1.0;
algorithm
  if w < powMax/tauMax then
    state := 0;
    yHidealised := tauMax;
  else
    state := 1;
    yHidealised := powMax/w;
  end if;
//over wMax the torque max is to be rapidly brought to zero
  if w > wMax then
    if w < (1 + alpha)*wMax then
      state := 2;
      yHidealised := powMax/wMax*(1 - (w - wMax)/(alpha*wMax));
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
    yH = toMinMaxTq.y[2];
    yL = toMinMaxTq.y[1];
  else
    yH = yHidealised;
    yL = -yHidealised;
  end if;
  connect(toMinMaxTq.u, w) annotation(
    Line(points = {{10, 0}, {-50, 0}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-40, -60}, {80, 60}}), graphics = {Line(origin = {51, 40}, points = {{-13, 0}, {13, 0}}, pattern = LinePattern.Dash), Line(origin = {50.7059, -40.2139}, points = {{-13, 0}, {13, 0}}, pattern = LinePattern.Dash), Text(origin = {89, -3}, textColor = {238, 46, 47}, extent = {{-53, 13}, {-13, -3}}, textString = "internal
connections"), Line(origin = {38.07, 0.65}, points = {{0, 37}, {0, 9}}, color = {255, 0, 0}, pattern = LinePattern.Dash, arrow = {Arrow.Filled, Arrow.None}), Line(origin = {38.4555, -44.0517}, points = {{0, 37}, {0, 9}}, color = {255, 0, 0}, pattern = LinePattern.Dash, arrow = {Arrow.None, Arrow.Filled})}),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 90}, {100, -88}}), Line(points = {{-72, 80}, {-72, -80}}, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 2), Text(textColor = {0, 0, 255}, extent = {{-98, 54}, {-84, 48}}, textString = "T"), Line(points = {{92, -2}, {-74, -2}}, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 2), Text(textColor = {0, 0, 255}, extent = {{72, -22}, {86, -28}}, textString = "W"), Line(points = {{-72, 54}, {-12, 54}, {2, 46}, {16, 26}, {30, 18}, {43.9863, 14.0039}, {86, 10}}, thickness = 0.5), Line(points = {{-72, -2}, {-62, -2}, {-52, -48}, {-8, -48}, {4, -42}, {16, -20}, {34, -12}, {86, -8}}, thickness = 0.5), Text(origin = {0, 2}, textColor = {0, 0, 255}, extent = {{-134, 128}, {134, 64}}, textString = "%name
          ")}),
    Documentation(info = "<html><head></head><body><p>Gives the maximum output torque as a function of the input speed. </p>
<p>There are two possibilities dependig on the value of limitsOnFile.</p>
<p><b>If limitsOnFile=false</b></p>
<p>When w&lt;wMax the output is Tmax if Tmax*w&lt;Pnom, otherwise it is Pnom/w </p>
<p>But if w is over wMax Tmax is rapidly falling to zero (reaches zero when speed overcomes wMax by 10%). </p>
<p><b>If limitsOnFile=true</b></p>
<p>maximum and minimum torques are taken from a txt file. Default interpaltion is with ontinuous derivative. No maxmimum speed is considered.</p>
<p><br>Torques and powers are in SI units </p><p><br></p><p>The simulation shows that up to 12 s and above 40s we are below baseSpeed and actual torque limit is maxTau; between 12 and 40s, we are under power limitation.&nbsp;</p><p>Suggested plots:</p><p>- OneFlange.variableLimter.limit1 with oneFlange.torque.tau, oneFlange.limTau.baseSpeed</p><p>- oneFlange.limTau.state</p><p>- oneflange.wMax and inertia.w.</p><p><br></p>
</body></html>"));
end LimTorque;
