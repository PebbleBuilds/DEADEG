const int relay1 = 11; //L discharge
const int relay2 = 12; //R discharge
const int relay3 = 10; //two-way relay

int period = 5; //period in seconds
int dischargeTime = 100; //discharge time in milliseconds
int dlay = 100; //delay

void setup() {
  // put your setup code here, to run once:
  pinMode(relay1, OUTPUT);
  pinMode(relay2, OUTPUT);
  pinMode(relay3, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(relay2, HIGH); //discharge DEA 2
  delay(dischargeTime);
  digitalWrite(relay2, LOW);

  delay(period*1000/2-dischargeTime-dlay); //voltage on DEA 1

  digitalWrite(relay3, LOW); //Apply voltage on DEA 2
  delay(dlay); //wait to discharge DEA 1

  digitalWrite(relay1,HIGH); //discharge DEA 1
  delay(dischargeTime);
  digitalWrite(relay1,LOW);

  delay(period*1000/2-dischargeTime-dlay); //Voltage on DEA 2

  digitalWrite(relay3, HIGH); //Apply voltage to DEA 1
  delay(dlay); 
}
