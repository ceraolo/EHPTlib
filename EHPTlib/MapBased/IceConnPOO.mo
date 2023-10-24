within EHPTlib.MapBased;
model IceConnPOO "Simple map-based ice model with connector; follows power request with ON-OFF"
  extends Partial.PartialIceP(toGramsPerkWh(fileName = mapsFileName));
  import Modelica.Constants.*;
  // rad/s
  parameter String mapsFileName = "maps.txt" "Name of the file containing data maps (names: maxIceTau, specificCons, optiSpeed)";
  SupportModels.ConnectorRelated.Conn conn annotation (
    Placement(visible = true, transformation(extent = {{-20, -78}, {20, -118}}, rotation = 0), iconTransformation(extent = {{-20, -78}, {20, -118}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator tokgFuel(k = 1 / 3.6e6) annotation (
    Placement(visible = true, transformation(origin = {38, -76}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch1 annotation (
    Placement(visible = true, transformation(origin = {2, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0) annotation (
    Placement(visible = true, transformation(extent = {{-46, -74}, {-26, -54}}, rotation = 0)));
  Modelica.Blocks.Math.Product toG_perHour annotation (
    Placement(visible = true, transformation(origin={38,-42},    extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(toG_perHour.u1, toGramsPerkWh.y) annotation (
    Line(points={{44,-30},{42,-30},{42,-13}},                   color = {0, 0, 127}));
  connect(switch1.y, toG_perHour.u2) annotation (
    Line(points={{13,-46},{20,-46},{20,-22},{32,-22},{32,-30}},                       color = {0, 0, 127}));
  connect(toG_perHour.y, tokgFuel.u) annotation (
    Line(points={{38,-53},{38,-64}},                            color = {0, 0, 127}));
  connect(tokW.y, switch1.u1) annotation (
    Line(points = {{-18, -29}, {-18, -29}, {-18, -38}, {-10, -38}, {-10, -38}}, color = {0, 0, 127}));
  connect(switch1.u3, zero.y) annotation (
    Line(points = {{-10, -54}, {-18.5, -54}, {-18.5, -64}, {-25, -64}}, color = {0, 0, 127}));
  connect(switch1.u2, conn.iceON) annotation (
    Line(points = {{-10, -46}, {-60, -46}, {-60, -82}, {0, -82}, {0, -98}}, color = {255, 0, 255}));
  connect(feedback.u1, conn.icePowRef) annotation (
    Line(points = {{-88, 52}, {-88, 52}, {-88, -98}, {0, -98}}, color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(Pice.power, conn.icePowDel) annotation (
    Line(points = {{68, 63}, {68, 63}, {68, 6}, {78, 6}, {78, -98}, {0, -98}}, color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(w.w, conn.iceW) annotation (
    Line(points = {{58, 25}, {58, 25}, {58, 6}, {58, -98}, {0, -98}}, color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 80}})),
    Documentation(info = "<html>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Simple map-based ICE model for power-split power trains - with connector</span></b> </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This is an evolution of IceConnP: ON/OFF control is added though an hysteresis block. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For its general operation see the description of IceConnP.</span></p>
</html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Text(origin = {34, -1}, lineColor = {255, 255, 255}, extent = {{32, -19}, {-48, 29}}, textString = "OO")}));
end IceConnPOO;
