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

public class GetEulerAngle_Erjie {
	double q0,q1,q2,q3;
	double  pitch , roll , yaw ;
	double PI = Math.PI;
	Scanner scanner = new Scanner(System.in);
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
			FileWriter writer = new FileWriter(new File("D:\\5.txt"));
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
			}
		
	
		for(int i = 0;i<t.size()-2;i++) {
					
				double wx1 =  (double) x.get(i) ;
				double wy1 = (double) y.get(i) ;
				double wz1 = (double) z.get(i) ;
				
				double wx2 = (double) x.get(i+1) ;
				double wy2 = (double) y.get(i+1) ;
				double wz2 = (double) z.get(i+1) ;
				
				double t1 = (double) t.get(i) ;
				double t2 = (double) t.get(i+1) ;
				double h = t2 - t1 ;

//				
				//更新四元数 二阶龙格
				
				double a1 [][] = {
						{0   ,-wx1  ,-wy1 ,-wz1},
						{wx1 ,  0   , wz1 , -wy1},
						{wy1 ,  -wz1 , 0   , wx1},
						{wz1 , wy1  , -wx1,  0 }
				};
				double a2 [][] = {
						{0   ,-wx2  ,-wy2 ,-wz2},
						{wx2 , 0 , wz2 ,  -wy2},
						{wy2 , -wz2 , 0 , wx2},
						{wz2 ,  wy2  , -wx2 ,0}
				};

				double q [][] = {
						{q0},
						{q1},
						{q2},
						{q3}
				};
				
				
				
				Matrix M_t1  = new Matrix(a1);
				Matrix M_t2  = new Matrix(a2);
				
				Matrix f1 = M_t1.times(0.5);
				Matrix f2 = M_t2.times(0.5);
				
				Matrix Q  = new Matrix(q);
				
				Matrix k1 = f1.times(Q);
				Matrix Y = Q.plus(k1.times(h));
				Matrix k2 = f2.times(Y);
				Matrix Q2 = Q.plus((k1.plus(k2)).times(h/2));
				
				
				double [][] b = Q2.getArray();
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
				roll = Math.atan((2*(q1*q3-q0*q2))/(2*(q1*q1+q2*q2)-1));
//				if(roll>0) {
//					if((1-2*(q1*q1+q2*q2))<0) {
//						roll = roll - PI;
//					}
//				}
//				else if(roll<0) {
//					if((1-2*(q1*q1+q2*q2))<0) {
//						roll = roll + PI;
//					}
//				}
				if((1-2*(q1*q1+q2*q2))<0) {
					if (roll>0) {
						roll = roll - PI;
					}
					else {
						roll = roll + PI;
					}
				}
//				if(roll - PI>0.005) {
//					roll = roll - 2*PI;
//				}
//				if(roll + PI<0.005) {
//					roll = roll + 2*PI;
//				}
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
						yaw = yaw  - PI;
					}
				
				}	
				if(yaw>PI) {
					yaw = yaw - PI;
				}
				else if(yaw<-PI) {
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
		  GetEulerAngle_Erjie s = new GetEulerAngle_Erjie(); 
		  s.test();
		  s.initAngle();
		  s.RungeKutta();
	  
	  }
	 
	
	
}
