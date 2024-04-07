# https://users.cecs.anu.edu.au/~bdm/data/graphs.html
library(rgraph6); library(igraph); library(matrixStats)
r=3; m=2; graphs=read_file6("graph5c.g6") # m+r=5
# r=5; m=3; graphs=read_file6("graph8c.g6") # m+r=8
count=0; total=0; trees=0; treesam=0; nontreesr=0; 
for (mat in graphs) {g=as.undirected(graph_from_adjacency_matrix(mat))
endpoints=combn(1:(m+r),m); lst = c();
for (k in 1:choose(m+r,m)) {
V(g)$color <- c(7, 2)[1 + V(g) %in% endpoints[,k]]
complement=setdiff(c(1:(m+r)),endpoints[,k])
if(sum(degree(subgraph(g,endpoints[,k])))==0 && is.connected(subgraph(g, complement)))
{if (all(sapply(lst, function(gg) !graph.isomorphic.vf2(g,gg)$iso))) {lst=c(lst,list(g)); 
count=count+1; a=0; exit=0; 
for (ii in complement) {a=max(a,sum(g[ii,endpoints[,k]]))}
for (i in (m+2):(m+r)){ for (j in 1:choose(m+r,i)){ 
h=subgraph(g, combn(1:(m+r),i)[,j])
if (((ecount(g)-a)/(vcount(g)-m-1))<((ecount(h)-a)/(vcount(h)-m-1))) {
exit=1;break;}}
if (exit==1) {break;}}
if (exit==0) {print(g); cat("a =",a,"\n"); total=total+1
trees=trees+is_tree(g)*(a==m)
treesam=treesam+is_tree(g)
nontreesr=nontreesr+!is_tree(subgraph(g, complement))
plot(g); print("Working ..."); 
}}}}}
cat("Tree with a<>m count = ", treesam, "; Tree count = ", trees, "out of total =",total,"out of",count,"\n");

