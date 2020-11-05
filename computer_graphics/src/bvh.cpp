#include "bvh.h"

#include "CMU462/CMU462.h"
#include "static_scene/triangle.h"

#include <algorithm>
#include <iostream>
#include <stack>

using namespace std;

namespace CMU462 {
namespace StaticScene {




Bucket* newBucket(){
    BBox bbox = BBox();
    Bucket* b = new Bucket(bbox,0);
    return b;
}

vector<Bucket * > initializeBuckets(){
    vector<Bucket *>  buckets;
    size_t n = 8;

    buckets.resize(n);

    for(size_t i=0; i<n; i++){
      buckets[i] = newBucket();
    }
    return buckets;
}

Bucket* compute_bucket(Vector3D centroid, size_t axis, vector<Bucket * > buckets, BBox bparent){

    double min = bparent.min[axis];
    double max = bparent.max[axis];


    size_t n = buckets.size();

    double dist = (double) bparent.extent[axis] / (float) n;


    for(int i=0; i< buckets.size();i++){
        double boundmin = min + i * dist;
        double boundmax = min + (i+1) * dist;

        if(centroid[axis] >= boundmin  &&  centroid[axis]<= boundmax ){
            return buckets[i];
        }
    }
    return buckets[0];

}


double evalSAH(BBox a, BBox b, size_t acount, size_t bcount, BBox total){
    double SA = a.surface_area();
    double SB = b.surface_area();
    double ST = total.surface_area();
    size_t NA = acount;
    size_t NB = bcount;
    return  (SA / ST) * NA  + (SB/ST) * NB;
}


double evalSAHNodes(BVHNode * a, BVHNode * b, BVHNode * parent){
    double SA = a->bb.surface_area();
    double SB = b->bb.surface_area();
    double ST = parent->bb.surface_area();
    size_t NA = a->range;
    size_t NB = b->range;
    return (SA/ST) * NA  + (SB/ST) * NB;
}


vector<BVHNode *> buildNode(BVHNode * parent, vector<Bucket *> buckets){
    //permute through all the partition possibility

    //evalSAH for each of the partition, find the lowest.
    //create left and right nodes following the root.
    //build the tree from the roots.
    //how to partition this.
    // how to serve the initial

    BBox bleft =BBox();
    BBox bright = BBox();
    size_t leftcount =0;
    size_t rightcount =0;
    double minValue = parent->range;

    for(int i = 1 ; i<buckets.size()-1; i++){

        BBox a = BBox();
        BBox b = BBox();
        size_t acount = 0;
        size_t bcount = 0;

        for (int j= 0; j< i; j++){
            a.expand(buckets[j]->bb);
            acount+= buckets[j]->count;
        }

        for (int k = i; k< buckets.size(); k++){
            if(!buckets[k]->bb.empty()){
                b.expand(buckets[k]->bb);
                bcount += buckets[k]->count;
            }
        }

        double cValue = evalSAH(a,b, acount, bcount, parent->bb);

        if(cValue <= minValue){
            minValue = cValue;
            bleft = a;
            bright = b;
            leftcount = acount;
            rightcount = bcount;
        }
    }

    vector<BVHNode *> nodes;
    nodes.resize(2);
    nodes[0] = new BVHNode(bleft,  parent->start, leftcount );
    nodes[1] = new BVHNode(bright, parent->start + leftcount , rightcount );

    return nodes;

}




bool compareX(Primitive * x1, Primitive * x2){

    return x1->get_bbox().centroid().x < x2->get_bbox().centroid().x;
}

bool compareY(Primitive * y1, Primitive * y2){

    return y1->get_bbox().centroid().y < y2->get_bbox().centroid().y;
}

bool compareZ(Primitive * z1, Primitive * z2){

    return z1->get_bbox().centroid().z < z2->get_bbox().centroid().z;
}



void sortByAxis(vector<Primitive *> &_primitives, size_t start, size_t range, size_t axis){


    if(axis==0){
        std::sort(_primitives.begin()+start,_primitives.begin()+start+range,compareX );
    }
    else if (axis ==1){
        std::sort(_primitives.begin()+start,_primitives.begin()+start+range, compareY );
    }

    else{
        std::sort(_primitives.begin()+start,_primitives.begin()+start+range, compareZ );
    }
}




void partition(vector<Primitive *> &_primitives, BVHNode* node){

    //for each axis, x,y,z;


    double minValue = node->range;
    BBox bb;
    BVHNode * LNode = new BVHNode(bb,0,0);
    BVHNode * RNode = new BVHNode(bb,0,0);

    size_t axis = 0;
    for(size_t i=0; i< 3; i++){
        if(node->bb.extent[i]==0){
            continue;
        }
        vector<Bucket *> buckets = initializeBuckets();


        sortByAxis(_primitives, node->start, node->range, i);

        for(size_t j = node->start ;  j < (node->start + node->range);  j++){

            Bucket* bucket = compute_bucket(_primitives[j]->get_bbox().centroid(), i, buckets, node->bb);
            bucket->bb.expand( _primitives[j]->get_bbox() );
            bucket->count +=1;

            }

            vector<BVHNode *> nodes = buildNode(node,buckets);

            double cValue = evalSAHNodes(nodes[0],nodes[1],node);

            //needs to make sure that it does not choose the axis that results nothing. for example, all primitives
            //along which axis have the same x value, so the partition will not work and have two empty nodes.
            if( cValue < minValue){
                minValue= cValue;
                LNode = nodes[0];
                RNode = nodes[1];
                axis = i;
            }
            else{
                free(nodes[0]);
                free(nodes[1]);
               nodes.clear();
            }

    }

    sortByAxis(_primitives, node->start, node->range, axis);
    node->l = LNode;
    node->r = RNode;

}


void buildTree(vector<Primitive *> &_primitives, BVHNode* x, size_t max_leaf_size){
    if(x->range <= max_leaf_size){
        return;
    }
    else{
        partition(_primitives , x);

        buildTree(_primitives, x->l,max_leaf_size);
        buildTree(_primitives, x->r,max_leaf_size);
    }
}





BVHAccel::BVHAccel(const std::vector<Primitive *> &_primitives,
                   size_t max_leaf_size) {


  this->primitives = _primitives;

  BBox bb;

  for (size_t i = 0; i < primitives.size(); ++i) {
    bb.expand(primitives[i]->get_bbox());
  }

  root = new BVHNode(bb, 0, primitives.size());


  buildTree(primitives, root, max_leaf_size);


}


void deleteBVH(BVHNode* x){
    if(x->isLeaf()){
        free(x);
    }
    else{
        deleteBVH(x->l);
        deleteBVH(x->r);
    }
}


BVHAccel::~BVHAccel() {
  //destroy the tree from bottom up.
  deleteBVH(root);
}



BBox BVHAccel::get_bbox() const { return root->bb; }



void find_closest(const vector<Primitive *> primitives, const Ray &ray, BVHNode* node, double &closest){

    if(node->isLeaf()){
        for(size_t p = node->start; p< (node->start + node->range); p++){

            bool hit = primitives[p]->intersect(ray);
            double t = ray.max_t ;

            if(hit && t < closest ){
                primitives[p]->intersect(ray);
                closest = t;
            }
        }
    }

    else{
        double t1 = INF_D ;double hit1=INF_D;  double t2 = INF_D ; double hit2=INF_D;

        node->l->bb.intersect(ray, t1, hit1);
        node->r->bb.intersect(ray,t2, hit2);

        if(hit1 == INF_D && hit2 ==INF_D){
            return;
        }

        double t3; double hit3= INF_D;


        BVHNode * first  = (hit1 <= hit2 ) ? node->l : node->r;
        BVHNode * second = (hit1 <= hit2) ? node->r : node->l;

        t3 = (hit1 <= hit2 ) ? t2 : t1;


        find_closest(primitives, ray, first, closest);


        if(   t3 < closest ){


            find_closest(primitives, ray, second, closest);
        }


    }
}







void BVHAccel::find_closest_hit(const Ray &ray, BVHNode* node, double &closest,
        Intersection * isect) const{

    if(node->isLeaf()){
        for(size_t p = node->start; p< (node->start + node->range); p++){
            bool hit = primitives[p]->intersect(ray,isect);
            double t = ray.max_t ;

            if(hit && t < closest ){
                //primitives[p]->intersect(ray,isect);
                closest = t;
            }
        }
    }

    else{
        double t1 = INF_D ;double hit1=INF_D;  double t2 = INF_D ; double hit2=INF_D;

        node->l->bb.intersect(ray, t1, hit1); node->r->bb.intersect(ray,t2, hit2);

        if(hit1 == INF_D && hit2 ==INF_D){
            return;
        }

        BVHNode * first  = (hit1 <= hit2 ) ? node->l :node->r;
        BVHNode * second = (hit1 <= hit2) ?  node->r : node->l;


        double t3 = (hit1 <= hit2 ) ? t2 : t1;

        find_closest_hit(ray, first, closest, isect);

        if( t3 < closest ){
            find_closest_hit(ray, second, closest, isect);
        }

    }
}



bool BVHAccel::intersect_node(const Ray &ray, BVHNode* node,
                    Intersection * isect) const {
    double t0, t1 = 0.0;

    if(!node->bb.intersect(ray,t0,t1)) return false;

    bool hit = false;
    if(node->isLeaf()){
        for(int i= node->start; i < node->start + node->range; i++){
            if(primitives[i]->intersect(ray,isect)) hit =true;
        }
        return hit;
    }
    else{

        double l0, l1, r0, r1 =0.0;
        bool hit1= false;
        if(node->l != nullptr && node->l->bb.intersect(ray,l0,l1))
            hit1= intersect_node(ray,node->l, isect);
        bool hit2= false;
        if(node->r != nullptr && node->r->bb.intersect(ray,r0,r1))
            hit2 = intersect_node(ray, node->r, isect);
        return hit1 || hit2;
    }

}



bool BVHAccel::intersect(const Ray &ray) const {

    bool hit = false;


    double thitnew = INF_D;

    find_closest(primitives,ray, root, thitnew);

    if(thitnew!=INF_D) {

        hit= true;
    }

    return hit;

}

bool BVHAccel::intersect(const Ray &ray, Intersection *isect) const {


  bool hit = false;

  double thit = INF_D;

  find_closest_hit(ray, root, thit, isect);

    if(thit!=INF_D) {
        hit= true;
    }

  return hit;

}

}  // namespace StaticScene
}  // namespace CMU462
