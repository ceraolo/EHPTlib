within EHPTlib.ElectricDrives.TestingModels;

model SmaDriveFW "Synchrnous Machine electric drive with flux weakening"
  //  extends Modelica.Icons.Example;
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.29, phi(fixed = true, start = 0), w(fixed = true, start = 0)) annotation(
    Placement(transformation(extent = {{72, -20}, {92, 0}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(extent = {{88, 28}, {108, 48}})));
  Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque tRes(w_nominal(displayUnit = "rpm") = 157.07963267949, tau_nominal = -100) annotation(
    Placement(transformation(extent = {{118, -20}, {98, 0}})));
  Modelica.Electrical.Machines.BasicMachines.SynchronousMachines.SM_PermanentMagnet smpm(useDamperCage = false) annotation(
    Placement(transformation(extent = {{30, -20}, {50, 0}}, rotation = 0)));
  Modelica.Electrical.Machines.Utilities.TerminalBox terminalBox1(terminalConnection = "Y") annotation(
    Placement(transformation(extent = {{30, 8}, {50, 28}}, rotation = 0)));
  Modelica.Electrical.Polyphase.Sources.SignalCurrent signalCurr1(final m = 3) annotation(
    Placement(transformation(origin = {40, 42}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Modelica.Electrical.Polyphase.Basic.Star star1(final m = 3) annotation(
    Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = 180, origin = {72, 52})));
  Modelica.Blocks.Sources.Constant uDC(k = 200) annotation(
    Placement(transformation(extent = {{-96, 32}, {-76, 52}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor wMeccSens annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {62, -24})));
  Modelica.Blocks.Continuous.Integrator integrator annotation(
    Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = -90, origin = {-10, -6})));
  ElectricDrives.SMArelated.FromPark fromPark(p = smpm.p) annotation(
    Placement(transformation(extent = {{-20, 32}, {0, 52}})));
  Modelica.Electrical.Analog.Basic.Ground groundM1 annotation(
    Placement(transformation(origin = {14, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  ElectricDrives.SMArelated.MTPAi myMTPA(Umax = 100, Ipm = smpm.permanentMagnet.Ie, pp = smpm.p, Rs = smpm.Rs, Ld = smpm.Lmd) annotation(
    Placement(visible = true, transformation(extent = {{-48, 32}, {-28, 52}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1[3](T = 0.2e-4*{1, 1, 1}) annotation(
    Placement(visible = true, transformation(origin = {18, 42}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp tqRef(height = 100, duration = 1) annotation(
    Placement(transformation(extent = {{-96, -38}, {-76, -18}})));
equation
  connect(myMTPA.wMech, integrator.u) annotation(
    Line(points = {{-50, 36}, {-58, 36}, {-58, -28}, {-10, -28}, {-10, -18}}, color = {0, 0, 127}));
  connect(fromPark.Xq, myMTPA.Iq) annotation(
    Line(points = {{-22, 36}, {-24, 36}, {-24, 36}, {-27, 36}}, color = {0, 0, 127}));
  connect(fromPark.Xd, myMTPA.Id) annotation(
    Line(points = {{-22, 48}, {-27, 48}}, color = {0, 0, 127}));
  connect(myMTPA.uDC, uDC.y) annotation(
    Line(points = {{-50, 42}, {-75, 42}}, color = {0, 0, 127}));
  connect(inertia.flange_b, tRes.flange) annotation(
    Line(points = {{92, -10}, {98, -10}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(terminalBox1.plug_sn, smpm.plug_sn) annotation(
    Line(points = {{34, 12}, {34, 0}}, color = {0, 0, 255}));
  connect(terminalBox1.plug_sp, smpm.plug_sp) annotation(
    Line(points = {{46, 12}, {46, 0}}, color = {0, 0, 255}));
  connect(star1.plug_p, signalCurr1.plug_p) annotation(
    Line(points = {{62, 52}, {40, 52}}, color = {0, 0, 255}));
  connect(star1.pin_n, ground.p) annotation(
    Line(points = {{82, 52}, {98, 52}, {98, 48}}, color = {0, 0, 255}));
  connect(inertia.flange_a, smpm.flange) annotation(
    Line(points = {{72, -10}, {50, -10}}, color = {0, 0, 0}));
  connect(signalCurr1.plug_n, terminalBox1.plugSupply) annotation(
    Line(points = {{40, 32}, {40, 14}}, color = {0, 0, 255}));
  connect(wMeccSens.flange, smpm.flange) annotation(
    Line(points = {{62, -14}, {62, -10}, {50, -10}}, color = {0, 0, 0}));
  connect(wMeccSens.w, integrator.u) annotation(
    Line(points = {{62, -35}, {62, -40}, {12, -40}, {12, -28}, {-10, -28}, {-10, -18}}, color = {0, 0, 127}));
  connect(integrator.y, fromPark.phi) annotation(
    Line(points = {{-10, 5}, {-10, 30}}, color = {0, 0, 127}));
  connect(groundM1.p, terminalBox1.starpoint) annotation(
    Line(points = {{24, 14}, {30, 14}}, color = {0, 0, 255}));
  connect(firstOrder1.u, fromPark.y) annotation(
    Line(points = {{8.4, 42}, {1, 42}}, color = {0, 0, 127}));
  connect(firstOrder1.y, signalCurr1.i) annotation(
    Line(points = {{26.8, 42}, {28, 42}}, color = {0, 0, 127}));
  connect(tqRef.y, myMTPA.torqueReq) annotation(
    Line(points = {{-75, -28}, {-66, -28}, {-66, 48}, {-50, 48}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {120, 80}}, initialScale = 0.1), graphics = {Text(origin = {-56, -50}, lineColor = {238, 46, 47}, extent = {{30, -4}, {98, -20}}, textString = "torque constant=1.564 Nm/A"), Rectangle(lineColor = {238, 46, 47}, pattern = LinePattern.Dash, extent = {{6, 62}, {54, 26}}), Text(lineColor = {238, 46, 47}, pattern = LinePattern.Dash, extent = {{52, 70}, {8, 66}}, textString = "simulates inverter")}),
    __Dymola_experimentSetupOutput,
    Documentation(info = "<html>
<p>Permanent magnet synchronous machine drive with MTPA control specifically designed for isotropic machines.</p>
<p>Initially the transient has low speed and no Id is needed: the control chose therefore Id=0.</p>
<p>Later speed increases and the control logic requires a negative Id to control machine voltage.</p>
<p>Here no control on current amplitude is implemented, and therefore during the end of the simulation current slightly overcomes machine&apos;s nominal value.</p>
</html>"),
    Icon(coordinateSystem(extent = {{-100, -80}, {120, 80}})),
    experiment(StopTime = 4, Interval = 0.001),
    __OpenModelica_commandLineOptions = "");
end SmaDriveFW;
