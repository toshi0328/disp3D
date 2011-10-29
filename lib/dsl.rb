# -*- coding: utf-8 -*-
require 'disp3D'

module Disp3D
  # SDLは３次元ビューに対して操作を行うための、ミニ言語である。
  # 基本的にユーザーはこのインターフェースによって、３次元ビューに対して操作する
  class GLView
    # 表示要素に対する操作
    # (例)
    # 括弧内は入れても入れなくてもよい
    # Create Point named point1 [0,0,0]
    # Create Points named points [[0,0,1], [1,0,1], [1,2,1]]
    # Create Line named line1 from[0,0,0] to[1,2,0]
    # Create Plane named plane1 base[0,0,0] normal[0,0,1]
    # Create Polyline named polyline1 (vertices) [[1,2,1], [1,4,3], [1,2,4]]
    # →これによって、geometryの要素を作成する
  end
end
