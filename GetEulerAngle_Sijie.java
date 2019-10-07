package aa;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;
import Jama.Matrix;

public class GetEulerAngle_Sijie {
	double q0,q1,q2,q3;
	double  pitch , roll , yaw ;
	double PI = Math.PI;
	Scanner scanner = new Scanner(System.in);
	double halfT = 0.02/2;
	GetEulerAngle angle = new GetEulerAngle();
	double norm ; 
	
	
	public void test() {
		System.out.println("输入航向角：");
		yaw = scanner.nextDouble();
		yaw = yaw*PI/180;
		roll = 0;
		pitch = 0;
		System.out.println(Math.sin(yaw));
		
	}
	public void initAngle() {
		 
			//初始化四元素
			q0 = Math.cos(yaw)*Math.cos(pitch)*Math.cos(roll)+Math.sin(yaw)*Math.sin(pitch)*Math.sin(roll);
			q1 = Math.cos(yaw)*Math.cos(pitch)*Math.sin(roll)-Math.sin(yaw)*Math.sin(pitch)*Math.cos(roll);
			q2 = Math.cos(yaw)*Math.sin(pitch)*Math.cos(roll)+Math.sin(yaw)*Math.cos(pitch)*Math.sin(roll);
			q3 = -Math.cos(yaw)*Math.sin(pitch)*Math.sin(roll)+Math.sin(yaw)*Math.cos(pitch)*Math.cos(roll);
			System.out.println(q0+" "+q1+" "+q2+" "+q3);
		
		
		
	}

	public void RungeKutta() {
		
		try {
			FileReader fileReader =new FileReader(new File("D:\\QQ系列\\QQ\\QQ文档\\704664122\\FileRecv\\t11.txt"));
			BufferedReader bufferedReader =new  BufferedReader(fileReader);
			FileWriter writer = new FileWriter(new File("D:\\4.txt"));
			BufferedWriter bufferedWriter = new BufferedWriter(writer);
			String line = null ;
			List x = new LinkedList<Double>();
			List y = new LinkedList<Double>();
			List z = new LinkedList<Double>();
			List t = new LinkedList<Double>();
			
			
			while((line = bufferedReader.readLine())!=null) {

				String [] s = line.split(",");
				if(s[0].equals("时间/s")) {
					continue;
				}
				
				x.add(Double.parseDouble(s[4]));
				y.add(Double.parseDouble(s[5]));
				z.add(Double.parseDouble(s[6]));
				t.add(Double.parseDouble(s[0]));
//				System.out.println(s[0]+"  "+s[4] +"  "+s[5]+"  "+s[6]);
			}
		
	
		for(int i = 0;i<t.size()-3;i++) {
					
				double wx1 =  (double) x.get(i) ;
				double wy1 = (double) y.get(i) ;
				double wz1 = (double) z.get(i) ;
				
				double wx2 = (double) x.get(i+1) ;
				double wy2 = (double) y.get(i+1) ;
				double wz2 = (double) z.get(i+1) ;
				
				double wx3 = (double) x.get(i+2) ;
				double wy3 = (double) y.get(i+2) ;
				double wz3 = (double) z.get(i+2) ;
				
				double time1 = (double) t.get(i) ;
				double time2 = (double) t.get(i+1) ;
				double time3 = (double) t.get(i+2) ;
				
				double dt1 = time2 - time1 ; 
				double dt2 = time3 - time2 ;
		
				//更新四元数 四阶龙格
				
				double a1 [][] = {
						{0   ,-wx1  ,-wy1 ,-wz1},
						{wx1 ,  0   , wz1 ,-wy1},
						{wy1 , -wz1 , 0   , wx1},
						{wz1 , wy1  , -wx1,  0 }
				};
				double a2 [][] = {
						{0   ,-wx2  ,-wy2 ,-wz2},
						{wx2 , 0 , wz2 , -wy2},
						{wy2 , -wz2 , 0 , wx2},
						{wz2 , wy2  , -wx2 ,0}
				};
				double a3 [][] = {
						{0   ,-wx3  ,-wy3 ,-wz3},
						{wx3 , 0 , wz3 , -wy3},
						{wy3 , -wz3 , 0 , wx3},
						{wz3 , wy3  , -wx3 ,0}
				};
				double a [][] = {
						{q0},
						{q1},
						{q2},
						{q3}
				};
				
				
				
				Matrix b1  = new Matrix(a1);
				Matrix b2  = new Matrix(a2);
				Matrix b3  = new Matrix(a3);
				Matrix E  = new Matrix(a);
				
				Matrix f1 = b1.times(0.5);
				Matrix f2 = b2.times(0.5);
				Matrix f3 = b3.times(0.5);
				
				Matrix k1 = f1.times(E);
				Matrix k2 = f2.times(E.plus(k1.times(dt1)));
				Matrix k3 = f2.times(E.plus(k2.times(dt2)));
				Matrix k4 = f3.times(E.plus(k3.times(dt2+dt1)));
				
				Matrix E1 = k1.plus(((k2.times(2)).plus(k3.times(2))).plus(k4));
				
				Matrix E2 = E.plus(E1.times((dt2+dt1)/6));
				
				double [][] b = E2.getArray();
				q0 = b[0][0];
				q1 = b[1][0];
				q2 = b[2][0];
				q3 = b[3][0];
				
				
				
				//规范化四元数
				norm = q0*q0+q1*q1+q2*q2+q3*q3;
				norm = Math.sqrt(norm);
				q0 = q0/norm ;
				q1 = q1/norm ;
				q2 = q2/norm ;
				q3 = q3/norm ;
				
				//转换为欧拉角
				//俯仰角
				pitch = Math.asin(2*(q2*q3+q0*q1))*57.3;
				
				//横滚角
				roll = Math.atan(-(2*(q1*q3-q0*q2))/(1-2*(q1*q1+q2*q2)));
				if((1-2*(q1*q1+q2*q2))<0) {
					if (roll>0) {
						roll = roll - PI;
					}
					else {
						roll = roll + PI;
					}
				}
				roll = roll*57.3;
				//航向角
				yaw = Math.atan((2*(q1*q2-q0*q3))/(1-2*(q1*q1+q3*q3)));
				if(Math.abs(1-2*(q1*q1+q3*q3))<0.01) {
					if(2*(q1*q2-q0*q3)>0) {
						yaw = PI/2;
					}else {
						yaw = -PI/2;
					}
				}
				else if(1-2*(q1*q1+q3*q3)>0) {
				yaw = Math.atan((2*(q1*q2-q0*q3))/(1-2*(q1*q1+q3*q3)));
				}
				else {
					
					if(2*(q1*q2-q0*q3)>0) {
						yaw = yaw+PI;
					}else {
						yaw = yaw-PI;
					}
				
				}	
				if(yaw>PI) {
					yaw = yaw - PI;
				}
				if(yaw<-PI) {
					yaw = yaw + PI;
				}
				yaw = yaw*57.3;
				
				
				
				
				System.out.println("俯仰角为："+pitch+"  横滚角为："+roll+" 航向角为："+yaw);
				
				line ="\t"+pitch +"\t"+roll+"\t"+yaw+"\r\n";
				bufferedWriter.write(i+line);
				
				System.out.println(i+"  "+wx1+"  "+wy1+"  "+wz1);
				
			}
			bufferedWriter.close();
			bufferedReader.close();
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	  public static void main(String[] args) { 
		  GetEulerAngle_Sijie s = new GetEulerAngle_Sijie(); 
		  s.test();
		  s.initAngle();
		  s.RungeKutta();
	  
	  }
	 
	
	
}
