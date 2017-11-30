public class User
{
  int stage;
  int weaponType=1;
  float HP=100;
  User(){
    stage = 1;
  }
  float attack()
  {
    return 20*weaponType;
  }
  void damage(float d)
  {
    HP-=d;
  }
}