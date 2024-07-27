within EHPTlib.MapBased;
model OneFlangeConn "Simple map-based one-flange electric drive"
  extends Partial.PartialOneFlangeFVCT;
  SupportModels.ConnectorRelated.Conn conn annotation (
    Placement(visible = true, transformation(extent = {{-18, -62}, {22, -102}}, rotation = 0), iconTransformation(extent={{70,-58},
            {110,-98}},                                                                                                                             rotation = 0)));
  Modelica.Blocks.Sources.RealExpression mechPow(y = powSensor.power) annotation (
    Placement(transformation(extent = {{38, -56}, {18, -36}})));
equation
  connect(wSensor.w, conn.genW) annotation (
    Line(points = {{78, 35.2}, {78, -72}, {2, -72}, {2, -82}}, color = {0, 0, 127}, smooth = Smooth.None),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(mechPow.y, conn.genPowDel) annotation (
    Line(points = {{17, -46}, {2, -46}, {2, -82}}, color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{-6, 3}, {-6, 3}}, horizontalAlignment = TextAlignment.Right));
  connect(variableLimiter.u, conn.genTauRef) annotation (
    Line(points = {{-2, 30}, {6, 30}, {6, -32}, {2, -32}, {2, -82}}, color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}, horizontalAlignment = TextAlignment.Left));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 80}})),
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2})),
    Documentation(info="<html>
<p>The input signal (supplied through connector: genTauRef) is interpreted as a <u>normalised</u> torque request (0 means null torque, 1 maximum availabile torque).</p>
<p>The maximum available torque is internally computed considering a direct torque maximum (tauMax) and a power maximum (powMax) </p>
<p>The requested torque is applied to a mechancal inertia. The inertia is interfaced by means ot two flanges with the exterior.</p>
<p>The model then computes the inner losses and absorbs the total power from the DC input.</p>
<p><br><u>Signals connected to the bus connecto</u>r (the names are chosen from the examples FullVehicles.PSecu1 and PSecu2 where the one-flange machine is called &quot;gen&quot;):</p>
<p>- genTauRef (input) is the torque request (Nm)</p>
<p>- genPowDel (output) is the delivered mechanical power (W)</p>
<p>- genTauLim (output) maximum available torque at the given machine rotational speed (Nm)</p>
</html>"));
end OneFlangeConn;
