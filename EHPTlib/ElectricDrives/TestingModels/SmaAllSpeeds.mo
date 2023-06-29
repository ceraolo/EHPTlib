within EHPTlib.ElectricDrives.TestingModels;
model SmaAllSpeeds
  //  extends Modelica.Icons.Example;
  parameter Real UIpeak = sqrt(2)*100;
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(extent={{70,18},{90,38}},      rotation = 0)));
  Modelica.Electrical.Machines.BasicMachines.SynchronousMachines.SM_PermanentMagnet smpm1(Lmd = 2e-3, Lmq = 4e-3, Lssigma(start = 1e-5),
    phiMechanical(displayUnit="rad"),
    useDamperCage=false,
    wMechanical(displayUnit="rad/s")) annotation (
    Placement(visible = true, transformation(extent={{-2,-58},{18,-38}},      rotation = 0)));
  Modelica.Electrical.Machines.Utilities.TerminalBox terminalBox1(terminalConnection = "Y") annotation (
    Placement(visible = true, transformation(extent={{-2,-34},{18,-14}},      rotation = 0)));
  Modelica.Electrical.Polyphase.Sources.SignalCurrent signalCurr1(final m = 3) annotation (
    Placement(visible = true, transformation(origin={22,32},    extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Modelica.Electrical.Polyphase.Basic.Star star1(final m = 3) annotation (
    Placement(visible = true, transformation(origin={54,42},    extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant uDC(k = 300) annotation (
    Placement(visible = true, transformation(extent={{-114,22},{-94,42}},      rotation = 0)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor wMeccSens annotation (
    Placement(visible = true, transformation(origin={30,-62},    extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.Integrator integrator annotation (
    Placement(visible = true, transformation(origin={-46,-16},    extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  EHPTlib.ElectricDrives.SMArelated.FromPark fromPark(p=smpm1.p) annotation (
      Placement(visible=true, transformation(extent={{-38,22},{-18,42}},
          rotation=0)));
  Modelica.Electrical.Analog.Basic.Ground groundM1 annotation (
    Placement(visible = true, transformation(origin={-18,-28},   extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  EHPTlib.ElectricDrives.SMArelated.MTPAalExperimental myMTPA(
    Ipm=smpm1.permanentMagnet.Ie,
    Ld=smpm1.Lmd,
    Lq=smpm1.Lmq,
    Rs=smpm1.Rs,
    Umax=100,
    gain=40.0,
    integTime=0.5,
    pp=smpm1.p) annotation (Placement(visible=true, transformation(extent={{-66,
            22},{-46,42}}, rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1[3](T = 0.2e-4*{1, 1, 1}) annotation (
    Placement(visible = true, transformation(origin={0,32},     extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant tqReq(k = 300) annotation (
    Placement(visible = true, transformation(extent={{-114,-12},{-94,8}},      rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.Speed speed annotation (
    Placement(visible = true, transformation(origin={78,-48},    extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp(duration = 7, height=317.0)   annotation (
    Placement(visible = true, transformation(origin={108,-48},    extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Polyphase.Sensors.ReactivePowerSensor qSens annotation (
    Placement(transformation(extent = {{-8, 8}, {8, -8}}, rotation = -90, origin={8,4})));
  Modelica.Electrical.Polyphase.Sensors.AronSensor pSens annotation (
    Placement(transformation(extent = {{-8, 8}, {8, -8}}, rotation = -90, origin={8,-16})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech
    annotation (Placement(transformation(extent={{44,-58},{64,-38}})));
equation
  connect(firstOrder1.y, signalCurr1.i) annotation (
    Line(points={{8.8,32},{10,32}},     color = {0, 0, 127}));
  connect(firstOrder1.u, fromPark.y) annotation (
    Line(points={{-9.6,32},{-17,32}},       color = {0, 0, 127}));
  connect(myMTPA.uDC, uDC.y) annotation (
    Line(points={{-68,32},{-93,32}},      color = {0, 0, 127}));
  connect(fromPark.Xd, myMTPA.Id) annotation (
    Line(points={{-40,38},{-45,38}},      color = {0, 0, 127}));
  connect(fromPark.Xq, myMTPA.Iq) annotation (
    Line(points={{-40,26},{-45,26}},      color = {0, 0, 127}));
  connect(myMTPA.wMech, integrator.u) annotation (
    Line(points={{-68,26},{-76,26},{-76,-38},{-46,-38},{-46,-28}}, color = {0, 0, 127}));
  connect(groundM1.p, terminalBox1.starpoint) annotation (
    Line(points={{-8,-28},{-2,-28}},    color = {0, 0, 255}));
  connect(integrator.y, fromPark.phi) annotation (
    Line(points={{-46,-5},{-46,8},{-28,8},{-28,20}},
                                          color = {0, 0, 127}));
  connect(wMeccSens.w, integrator.u) annotation (
    Line(points={{30,-73},{30,-76},{-46,-76},{-46,-28}},          color = {0, 0, 127}));
  connect(wMeccSens.flange, smpm1.flange) annotation (
    Line(points={{30,-52},{30,-48},{18,-48}}));
  connect(star1.pin_n, ground.p) annotation (
    Line(points={{64,42},{80,42},{80,38}},        color = {0, 0, 255}));
  connect(star1.plug_p, signalCurr1.plug_p) annotation (
    Line(points={{44,42},{22,42}},      color = {0, 0, 255}));
  connect(terminalBox1.plug_sp, smpm1.plug_sp) annotation (
    Line(points={{14,-30},{14,-38}},      color = {0, 0, 255}));
  connect(terminalBox1.plug_sn, smpm1.plug_sn) annotation (
    Line(points={{2,-30},{2,-38}},        color = {0, 0, 255}));
  connect(myMTPA.torqueReq, tqReq.y) annotation (
    Line(points={{-68,38},{-84,38},{-84,-2},{-93,-2}},          color = {0, 0, 127}));
  connect(ramp.y, speed.w_ref) annotation (
    Line(points={{97,-48},{90,-48}},        color = {0, 0, 127}));
  connect(pSens.plug_n, terminalBox1.plugSupply) annotation (
    Line(points={{8,-24},{8,-28}},        color = {0, 0, 255}));
  connect(qSens.plug_n, pSens.plug_p) annotation (
    Line(points={{8,-4},{8,-8}},        color = {0, 0, 255}));
  connect(signalCurr1.plug_n, qSens.plug_p) annotation (
    Line(points={{22,22},{22,12},{8,12}},
                                        color = {0, 0, 255}));
  connect(speed.flange, powMech.flange_b)
    annotation (Line(points={{68,-48},{64,-48}}, color={0,0,0}));
  connect(powMech.flange_a, smpm1.flange)
    annotation (Line(points={{44,-48},{18,-48}}, color={0,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-120,
            -80},{120,60}}),graphics={  Rectangle(origin={-16,-114},
lineColor = {238, 46, 47}, pattern = LinePattern.Dash, extent = {{4, 166}, {52, 130}})}),
    __Dymola_experimentSetupOutput,
    Documentation(info = "<html>
    <p>Permanent magnet synchronous machine drive with MTPA control specifically designed for isotropic machines.</p>
    <p>Initially the transient has low speed and no Id is needed: the control chose therefore Id=0.</p>
    <p>Later speed increases and the control logic requires a negative Id to control machine voltage.</p>
    <p>Here control on current amplitude <b>is </b>implemented, which becomes active during the central part of the simulation; in this case only part of the requested toque is delivered.</p>
    </html>"),
    Icon(coordinateSystem(extent={{-120,-80},{120,60}},
          preserveAspectRatio=false)),
    experiment(StopTime = 10, Interval = 0.0005, Tolerance = 1e-06, StartTime = 0),
    __OpenModelica_commandLineOptions = "");
end SmaAllSpeeds;
