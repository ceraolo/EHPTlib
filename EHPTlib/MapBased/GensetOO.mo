within EHPTlib.MapBased;
model GensetOO "GenSet GMS+GEN+SEngine with On/Off"
  extends Partial.PartialGenset;
  ECUs.GMSoo gms(mapsFileName = mapsFileName, throttlePerWerr = 0.1, nomTorque = actualTauMax, nomSpeed = actualSpeedMax) annotation (
    Placement(visible = true, transformation(extent = {{-70, 8}, {-50, 28}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput ON "when true engine is ON" annotation (
    Placement(visible = true, transformation(origin = {-59, 107}, extent = {{15, -15}, {-15, 15}}, rotation = 90), iconTransformation(origin = {-60, 116}, extent = {{15, -15}, {-15, 15}}, rotation = 90)));
equation
  connect(gms.Wmecc, gain1.y) annotation (
    Line(points = {{-59.9, 6.5}, {-60, 6}, {-60, -1.4}}, color = {0, 0, 127}));
  connect(gms.throttle, iceT.nTauRef) annotation (
    Line(points = {{-49, 12}, {-44, 12}, {-44, -10}, {-30, -10}, {-30, -2.22}}, color = {0, 0, 127}));
  connect(gms.pRef, limiter.y) annotation (
    Line(points = {{-72, 18}, {-80, 18}, {-80, 43}}, color = {0, 0, 127}));
  connect(gain.u, gms.tRef) annotation (
    Line(points = {{-16, 40}, {-40, 40}, {-40, 24}, {-49, 24}}, color = {0, 0, 127}));
  connect(ON, gms.on) annotation (
    Line(points = {{-59, 107}, {-59, 36}, {-76, 36}, {-76, 24}, {-71.8, 24}}, color = {255, 0, 255}));
  annotation (
    Documentation(info = "<html>
<p>For the general comments see info of Genset.</p>
<p>Here we have the ON-OFF input to command switching the ICE ON and OFF.</p>
</html>"));
end GensetOO;
