{
  fetchurl,
  fetchFromGitHub,
  python3,
  ...
}: {
  data = {
    "dlib_face_recognition_resnet_model_v1.dat" = fetchurl {
      url = "https://github.com/davisking/dlib-models/raw/master/dlib_face_recognition_resnet_model_v1.dat.bz2";
      sha256 = "0fjm265l1fz5zdzx5n5yphl0v0vfajyw50ffamc4cd74848gdcdb";
    };
    "mmod_human_face_detector.dat" = fetchurl {
      url = "https://github.com/davisking/dlib-models/raw/master/mmod_human_face_detector.dat.bz2";
      sha256 = "117wv582nsn585am2n9mg5q830qnn8skjr1yxgaiihcjy109x7nv";
    };
    "shape_predictor_5_face_landmarks.dat" = fetchurl {
      url = "https://github.com/davisking/dlib-models/raw/master/shape_predictor_5_face_landmarks.dat.bz2";
      sha256 = "0wm4bbwnja7ik7r28pv00qrl3i1h6811zkgnjfvzv7jwpyz7ny3f";
    };
  };

  src = fetchFromGitHub {
    owner = "fufexan";
    repo = "howdy";
    rev = "dceebf0f194e55429baaf9696ed5ae38ab9ddf92";
    hash = "sha256-6C8AqB83pJ5LMq+0JdsrMfkGNxxn1uv8jfoCe8BAGeY=";
  };

  py = python3.withPackages (p: [
    p.face_recognition
    (p.opencv4.override {enableGtk3 = true;})
  ]);
}
