<?php
/**
 * Created by PhpStorm.
 * User: jerry
 * Date: 17/4/13
 * Time: 下午2:11
 */

$userId = $_POST["account"];
$password = $_POST["password"];



if ($userId=="Jerry" && $password=="123"){

    // 去云信服务器申请token，返回给客户

    $token = md5($password);
    $res = array("result" => "1","msg"=>"登录成功","NIMToken"=>$token);

    exit(json_encode($res));

}else{

    if ($userId != "Jerry"){

        $res = array("result" => "0","msg"=>"无此用户");
        exit(json_encode($res));

    }else{

        if ($password != "123"){

            $res = array("result" => "0","msg"=>"密码错误");
            exit(json_encode($res));

        }
    }

}

