package com.pronix.knowledge;

import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.*;
import java.text.*;

public class Launch
{
  /**
   * @param args the command line arguments
   */
  public static void main(String[] args)
  {
     org.jruby.Main.main(new String[]{"-e require 'main.rb'"});
  }

  private static byte[] encrypt(String to_encrypt) throws Exception {
     SecretKeySpec key = new SecretKeySpec(privateKey.getBytes(), algorithm);
     Cipher cipher = Cipher.getInstance(algorithm);
     cipher.init(Cipher.ENCRYPT_MODE, key);
     return cipher.doFinal(to_encrypt.getBytes());
  }

  private static String decrypt(byte[] to_decrypt) throws Exception {
     SecretKeySpec key = new SecretKeySpec(privateKey.getBytes(), algorithm);
     Cipher cipher = Cipher.getInstance(algorithm);
     cipher.init(Cipher.DECRYPT_MODE, key);
     return new String(cipher.doFinal(to_decrypt));
  }

  private static List checkRangString(String str)
  {
     List list = null;
     try
     {
        String res[] = str.split("\\|");
        int days = Integer.parseInt(res[1], 16);
        
        Date startDate = new Date(Long.parseLong(res[0], 16));
        Date boundDate = new Date(-2179121292254L);
        Date resDate = boundDate.after(startDate) ? new Date() : startDate;

        list = new ArrayList(2);
        list.add(resDate);
        list.add(new Long(days));
     }
     catch (Exception e) {e.printStackTrace();}
     return list;
  }

  private static byte[] fromHex(String s) {
     int len = s.length();
     byte[] data = new byte[len / 2];
     for (int i = 0; i < len; i += 2) {
        data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                              + Character.digit(s.charAt(i+1), 16));
     }
     return data;
  }

  private static String privateKey = "test1234";
  private static String algorithm = "Blowfish";

  public static List check(String str)
  {
     List res = null;
     try
     {
        res = checkRangString(decrypt(fromHex(str)));
     }
     catch (Exception e)
     {
     }
     return res;
  }
}
