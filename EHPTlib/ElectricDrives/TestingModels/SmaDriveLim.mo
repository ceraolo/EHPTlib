within EHPTlib.ElectricDrives.TestingModels;
model SmaDriveLim
  //  extends Modelica.Icons.Example;
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.29, phi(fixed = true, start = 0), w(fixed = true, start = 0)) annotation (
    Placement(transformation(extent = {{70, 84}, {90, 104}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(transformation(extent = {{86, 132}, {106, 152}})));
  Modelica.Electrical.Machines.BasicMachines.SynchronousMachines.SM_PermanentMagnet
    smpm1(
    useDamperCage=false,
    Lmd=1.91e-3,
    Lmq=1.91e-3) annotation (Placement(transformation(extent={{28,84},{48,
            104}}, rotation=0)));
  Modelica.Electrical.Machines.Utilities.TerminalBox terminalBox1(terminalConnection = "Y") annotation (
    Placement(transformation(extent = {{28, 112}, {48, 132}}, rotation = 0)));
  Modelica.Electrical.Polyphase.Sources.SignalCurrent signalCurr1(final m=
       3) annotation (Placement(transformation(
        origin={38,146},
        extent={{-10,10},{10,-10}},
        rotation=270)));
  Modelica.Electrical.Polyphase.Basic.Star star1(final m=3) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={70,156})));
  Modelica.Blocks.Sources.Constant uDC(k = 200) annotation (
    Placement(transformation(extent = {{-98, 136}, {-78, 156}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor wMeccSens annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {60, 80})));
  Modelica.Blocks.Continuous.Integrator integrator annotation (
    Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = -90, origin = {-12, 98})));
  SMArelated.FromPark fromPark(p = smpm1.p) annotation (
    Placement(transformation(extent = {{-22, 136}, {-2, 156}})));
  Modelica.Electrical.Analog.Basic.Ground groundM1 annotation (
    Placement(transformation(origin = {12, 118}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  SMArelated.MTPAal myMTPA(
    Umax=100,
    Ipm=smpm1.permanentMagnet.Ie,
    pp=smpm1.p,
    Rs=smpm1.Rs,
    Ld=smpm1.Lmd,
    Lq=smpm1.Lmq) annotation (Placement(visible=true, transformation(extent={{-50,
            136},{-30,156}}, rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1[3](T = 0.2e-4 * {1, 1, 1}) annotation (
    Placement(visible = true, transformation(origin = {16, 146}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Trapezoid tqRef(rising = 2, period = 1e6, amplitude = 180, falling = 2, startTime = 1, width = 4) annotation (
    Placement(transformation(extent = {{-98, 100}, {-78, 120}})));
  Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque tRes(tau_nominal = -150, w_nominal(displayUnit = "rpm") = 157.07963267949) annotation (
    Placement(transformation(extent = {{116, 84}, {96, 104}})));
equation
  connect(myMTPA.wMech, integrator.u) annotation (
    Line(points = {{-52, 140}, {-60, 140}, {-60, 76}, {-12, 76}, {-12, 86}}, color = {0, 0, 127}));
  connect(fromPark.Xq, myMTPA.Iq) annotation (
    Line(points = {{-24, 140}, {-29, 140}}, color = {0, 0, 127}));
  connect(fromPark.Xd, myMTPA.Id) annotation (
    Line(points = {{-24, 152}, {-29, 152}}, color = {0, 0, 127}));
  connect(myMTPA.uDC, uDC.y) annotation (
    Line(points = {{-52, 146}, {-77, 146}}, color = {0, 0, 127}));
  connect(terminalBox1.plug_sn, smpm1.plug_sn) annotation (
    Line(points = {{32, 116}, {32, 104}}, color = {0, 0, 255}));
  connect(terminalBox1.plug_sp, smpm1.plug_sp) annotation (
    Line(points = {{44, 116}, {44, 104}}, color = {0, 0, 255}));
  connect(star1.plug_p, signalCurr1.plug_p) annotation (
    Line(points = {{60, 156}, {38, 156}}, color = {0, 0, 255}));
  connect(star1.pin_n, ground.p) annotation (
    Line(points = {{80, 156}, {96, 156}, {96, 152}}, color = {0, 0, 255}));
  connect(inertia.flange_a, smpm1.flange) annotation (
    Line(points = {{70, 94}, {48, 94}}, color = {0, 0, 0}));
  connect(signalCurr1.plug_n, terminalBox1.plugSupply) annotation (
    Line(points = {{38, 136}, {38, 118}}, color = {0, 0, 255}));
  connect(wMeccSens.flange, smpm1.flange) annotation (
    Line(points = {{60, 90}, {60, 94}, {48, 94}}, color = {0, 0, 0}));
  connect(wMeccSens.w, integrator.u) annotation (
    Line(points = {{60, 69}, {60, 64}, {10, 64}, {10, 76}, {-12, 76}, {-12, 86}}, color = {0, 0, 127}));
  connect(integrator.y, fromPark.phi) annotation (
    Line(points = {{-12, 109}, {-12, 134}}, color = {0, 0, 127}));
  connect(groundM1.p, terminalBox1.starpoint) annotation (
    Line(points = {{22, 118}, {28, 118}}, color = {0, 0, 255}));
  connect(firstOrder1.u, fromPark.y) annotation (
    Line(points = {{6.4, 146}, {-1, 146}}, color = {0, 0, 127}));
  connect(firstOrder1.y, signalCurr1.i) annotation (
    Line(points = {{24.8, 146}, {26, 146}}, color = {0, 0, 127}));
  connect(tqRef.y, myMTPA.torqueReq) annotation (
    Line(points = {{-77, 110}, {-68, 110}, {-68, 152}, {-52, 152}}, color = {0, 0, 127}));
  connect(inertia.flange_b, tRes.flange) annotation (
    Line(points = {{90, 94}, {96, 94}}, color = {0, 0, 0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, 40}, {120, 180}}), graphics={  Rectangle(extent = {{4, 166}, {52, 130}}, lineColor = {238, 46, 47}, pattern = LinePattern.Dash), Text(extent = {{50, 172}, {6, 170}}, lineColor = {238, 46, 47}, pattern = LinePattern.Dash, textString = "simulates inverter")}),
    __Dymola_experimentSetupOutput,
    Documentation(info = "<html>
<p>Permanent magnet synchronous machine drive with MTPA control specifically designed for isotropic machines.</p>
<p>Initially the transient has low speed and no Id is needed: the control chose therefore Id=0.</p>
<p>Later speed increases and the control logic requires a negative Id to control machine voltage.</p>
<p>Here control on current amplitude <b>is </b>implemented, which becomes active during the central part of the simulation; in this case only part of the requested toque is delivered.</p>
</html>"),
    Icon(coordinateSystem(extent = {{-100, 40}, {120, 180}})),
    experiment(StopTime = 10, Interval = 0.001),
    __OpenModelica_commandLineOptions = "");
end SmaDriveLim;
